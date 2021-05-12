# Sample low-code vault policies testing implementation

import unittest
import subprocess
import json
import os
import random
import string

# Read vault credentials
VAULT_ACCESS = {
    "VAULT_TOKEN": os.environ['VAULT_TOKEN'],
    "VAULT_ADDR": os.environ['VAULT_ADDR']
}

# A simple wrapper to run a command in vault cli
def run(command, token='', silent=False):
    print(str("############################################"))
    if token: os.environ["VAULT_TOKEN"] = token
    print(command)
    proc = subprocess.Popen(command,
        stdout=subprocess.PIPE, 
        stderr=subprocess.STDOUT, 
        shell=True)
    stdout = proc.stdout.read()
    print(str(stdout))
    return stdout

# Get output from terraform
TERRAFORM_OUTPUT_PRODUCT1=json.loads(run('terraform output -json', silent=True))\
        ["outputs"]["value"]["application01_prod"]

# Retrieves vault token for a specific service name
def get_token(service):
    cmd = "vault write -f auth/{meta[product]}/{meta[environment]}/approle/role/{approle}/secret-id --format=json"
    secret_id_output = run(cmd.format(
        approle=TERRAFORM_OUTPUT_PRODUCT1[service]['approle'],
        **TERRAFORM_OUTPUT_PRODUCT1
    ))
    secret_id = json.loads(secret_id_output)['data']['secret_id']
    cmd = "vault write -f auth/{meta[product]}/{meta[environment]}/approle/login role_id={role_id} secret_id={secret_id} --format=json"
    token_output = run(cmd.format(
        role_id=TERRAFORM_OUTPUT_PRODUCT1[service]['role_id'],
        secret_id=secret_id,
        **TERRAFORM_OUTPUT_PRODUCT1
    ))
    return json.loads(token_output)['auth']['client_token']


TOKEN_SERVICE1 = get_token("service01")
TOKEN_SERVICE2 = get_token("service02")

class TestVault(unittest.TestCase):
    def setUp(self):
        self.ctx = TERRAFORM_OUTPUT_PRODUCT1
  
    def assertStr(self, output, expected):
        self.assertTrue(expected in output)

    def tearDown(self):
        pass
 
    def test_01_kv_individual_s01_put(self):
        # Test that service01 can put a personal secret
        self.assertStr(run("vault kv put {meta[product]}/{meta[environment]}/kv/service01/secret01 b=12345"\
            .format(**self.ctx), token = TOKEN_SERVICE1), "created_time")

    def test_02_kv_individual_s01_get(self):
        # Test that service01 can get a personal secret
        self.assertStr(run("vault kv get {meta[product]}/{meta[environment]}/kv/service01/secret01"\
            .format(**self.ctx), token = TOKEN_SERVICE1), "12345")

    def test_03_kv_individual_s02_put(self):
        # Test that service02 can put a personal secret
        self.assertStr(run("vault kv put {meta[product]}/{meta[environment]}/kv/service02/secret01 b=23456"\
            .format(**self.ctx), token = TOKEN_SERVICE2), "created_time")

    def test_04_kv_individual_s02_get(self):
        # Test that service02 can get a personal secret
        self.assertStr(run("vault kv get {meta[product]}/{meta[environment]}/kv/service02/secret01"\
            .format(**self.ctx), token = TOKEN_SERVICE2), "23456")

    def test_05_kv_negative_put(self):
        # Test that service cannot put a secret to other service
        self.assertStr(run("vault kv put {meta[product]}/{meta[environment]}/kv/service01/secret01 b=1"\
            .format(**self.ctx), token = TOKEN_SERVICE2), "403")

    def test_06_kv_negative_get(self):
        # Test that service cannot retrieve a secret of other service
        self.assertStr(run("vault kv get {meta[product]}/{meta[environment]}/kv/service02/secret02"\
            .format(**self.ctx), token = TOKEN_SERVICE1), "403")

    def test_07_kv_common_put(self):
        self.ctx['nsw'] = 'NEWSECRETVALUE'
        # Test can put in self common storage
        self.assertStr(run("vault kv put {meta[product]}/{meta[environment]}/kv/common/service01/secret01 b={nsw}"\
            .format(**self.ctx), token = TOKEN_SERVICE1), "created_time")

    def test_08_kv_common_cannot_put_other(self):
        # Test cannot put in other common storage
        res = run("vault kv put {meta[product]}/{meta[environment]}/kv/common/service02/secret01 b=1"\
            .format(**self.ctx), token = TOKEN_SERVICE1)
        self.assertStr(res, "403")

    def test_09_kv_common_can_read(self):
        # Test service can read in self storage
        self.assertStr(run("vault kv get {meta[product]}/{meta[environment]}/kv/common/service01/secret01"\
            .format(**self.ctx), token = TOKEN_SERVICE1), 'NEWSECRETVALUE')

    def test_10_kv_common_can_read_other(self):
        # Test other service can read in self storage
        self.assertStr(run("vault kv get {meta[product]}/{meta[environment]}/kv/common/service01/secret01"\
            .format(**self.ctx), token = TOKEN_SERVICE2), 'NEWSECRETVALUE')

    def test_11_transit_key_can_write_self(self):
        # Test can write own key
        self.assertStr(run("vault write -f {meta[product]}/{meta[environment]}/transit/keys/service01" \
            .format(**self.ctx), token = TOKEN_SERVICE1), "Data written")

    def test_12_transit_key_can_write_other(self):
        # Test cannot write key for other service
        self.assertStr(run("vault write -f {meta[product]}/{meta[environment]}/transit/keys/service02" \
            .format(**self.ctx), token = TOKEN_SERVICE1), "403")

    def test_13_transit_encrypt(self):
        self.assertStr(run("vault write -f {meta[product]}/{meta[environment]}/transit/encrypt/service01 plaintext=$(echo test | base64)" \
            .format(**self.ctx), token = TOKEN_SERVICE1), "ciphertext")

if __name__ == '__main__':
    unittest.main(failfast=True)