FROM vault

COPY vault.json /vault/config/vault.json

ENTRYPOINT [ "vault", "server", "-config=/vault/config/vault.json" ]
