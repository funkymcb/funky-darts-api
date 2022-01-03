FROM gcr.io/distroless/static:nonroot

COPY ./out/api /bin/funky-darts-api

ENTRYPOINT [ "funky-darts-api" ]
