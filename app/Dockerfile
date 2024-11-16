FROM golang:1.23.2-alpine3.20

ENV APP_ROOT=/app/golang

COPY ./golang $APP_ROOT
WORKDIR $APP_ROOT

RUN go mod download
RUN go build -o main .

CMD ["/app/golang/main"]
