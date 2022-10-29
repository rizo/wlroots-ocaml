FROM nixos/nix
RUN nix-channel --update

WORKDIR /app

# Copy everything necessary to build the dependencies.
# ./.gitignore is required as it's used in ./onix-lock.nix.
COPY ./.gitignore ./default.nix ./onix-lock.nix /app/

# Pre-build the shell.
RUN nix-build -A shell default.nix