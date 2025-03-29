#!/bin/bash

systemctl --user enable mitmproxy.service
systemctl --user start mitmproxy.service

sudo trust anchor ~/.config/mitmproxy/mitmproxy-ca-cert.pem
