# Set host = (personal-macbook|work-macbook)
bootstrap host:
    ./bootstrap "{{ host }}"

# Set host = (personal-macbook|work-macbook)
init host:
    ./box/"{{ host }}"/init "{{ host }}"

# Install homebrew, if not already installed
brew:
    @if [[ ! -e /opt/homebrew/bin/brew ]]; then \
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
    fi
