#!/usr/bin/env sh

xargs pip install --target ~/.python-packages --upgrade <<EOF
black==24.8.0
pyright==1.1.362
debugpy==1.8.5
mitmproxy==10.3.0
EOF

