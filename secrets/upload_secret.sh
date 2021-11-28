if [[ -f ".envrc" ]]; then
    gsutil cp .envrc gs://mitou-jr-secret/.envrc 
else
    echo ".envrc not existed."
fi