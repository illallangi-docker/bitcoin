FROM illallangi/ansible:latest as build
COPY build/* /etc/ansible.d/build/
RUN /usr/local/bin/ansible-runner.sh build

FROM illallangi/ansible:latest as image

COPY --from=build /usr/local/src/*.tar.gz /usr/local/src/
COPY --from=build /usr/local/src/bitcoin-0.15.1/bin/bitcoin-cli /usr/local/bin/
COPY --from=build /usr/local/src/bitcoin-0.15.1/bin/bitcoin-qt /usr/local/bin/
COPY --from=build /usr/local/src/bitcoin-0.15.1/bin/bitcoin-tx /usr/local/bin/
COPY --from=build /usr/local/src/bitcoin-0.15.1/bin/bitcoind /usr/local/bin/
COPY --from=build /usr/local/src/bitcoin-0.15.1/bin/test_bitcoin /usr/local/bin/

COPY image/* /etc/ansible.d/image/
RUN /usr/local/bin/ansible-runner.sh image

COPY container/* /etc/ansible.d/container/
CMD ["/usr/local/bin/bitcoind"]

USER bitcoin
WORKDIR /var/lib/bitcoin
