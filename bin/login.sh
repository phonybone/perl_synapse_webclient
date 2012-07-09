curl -k -H "Content-Type:application/json" -H "Accept:application/json" \
-d "{\"email\":\"phonybone@gmail.com\", \"password\":\"Bsa441\", \"acceptsTermsOfUse\":\"true\"}" \
-X POST https://auth-prod.sagebase.org/auth/v1/session