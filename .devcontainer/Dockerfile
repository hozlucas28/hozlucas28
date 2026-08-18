FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

USER vscode

# Set shell to bash
ENV SHELL="/bin/bash"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Set versions for dependencies
ARG uv_version="0.11.32"
ARG python_version="3"

ARG fnm_version="1.39.0"
ARG nodejs_version="24"

ARG zizmor_version=">=1.0.0,<2.0.0"
ARG rendercv_version=">=2.0.0,<3.0.0"

ARG oxfmt_version="0"
ARG lefthook_version="2"

ARG act_version="0.2.89"
ARG github_cli_version="2.96.0"

# Set PATH for installed binaries
ARG fnm_path="/home/vscode/.local/share/fnm/aliases/default/bin"

ENV PNPM_HOME="/home/vscode/.local/share/pnpm"
ENV PATH="/home/vscode/.local/bin:$fnm_path:$PNPM_HOME/bin:$PATH"

# Install uv and Python
RUN <<EOF
    curl -LsSf https://astral.sh/uv/${uv_version}/install.sh | sh
    uv python install ${python_version} --default
EOF

# Install fnm, Node.js and pnpm
RUN <<EOF
    curl -fsSL https://fnm.vercel.app/install | bash -s -- --release v${fnm_version} --install-dir "/home/vscode/.local/bin"

    eval "$(/home/vscode/.local/bin/fnm env)"
    echo 'eval "$(fnm env)"' >> "/home/vscode/.bashrc"

    fnm install ${nodejs_version}
    fnm default ${nodejs_version}

    corepack enable pnpm
    pnpm setup
EOF

# Install packages
RUN uv tool install zizmor${zizmor_version}
RUN uv tool install rendercv[full]${rendercv_version}

RUN <<EOF
    pnpm install \
        --global \
        --unsafe-perm \
        oxfmt@^${oxfmt_version} \
        lefthook@^${lefthook_version}
EOF

# Install act
RUN <<EOF
    curl --proto '=https' --tlsv1.2 -sSf "https://raw.githubusercontent.com/nektos/act/refs/tags/v${act_version}/install.sh" \
        | sudo bash
EOF

# Install GitHub CLI
RUN <<EOF
    curl -fsSL "https://github.com/cli/cli/releases/download/v${github_cli_version}/gh_${github_cli_version}_linux_amd64.tar.gz" \
        | tar -xzf - -C "/home/vscode/.local/bin" --strip-components=2 "gh_${github_cli_version}_linux_amd64/bin/gh"
EOF

CMD [ "sleep", "infinity" ]
