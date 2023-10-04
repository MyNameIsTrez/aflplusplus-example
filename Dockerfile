FROM aflplusplus/aflplusplus:v4.08c

RUN apt update && apt install -y screen tmux

# Allow using the mouse in tmux
RUN { \
		echo "set -g mouse on"; \
	} > ~/.tmux.conf

# Allow using the mouse in screen
RUN { \
		echo "mousetrack on"; \
		echo "defmousetrack on"; \
	} > ~/.screenrc

RUN ln -s /src/scripts/coverage.sh /usr/bin/
RUN ln -s /src/scripts/fuzz.sh /usr/bin/
RUN ln -s /src/scripts/minimize_crashes.sh /usr/bin/
RUN ln -s /src/scripts/setup.sh /usr/bin/

WORKDIR /src

# CMD [ "setup.sh" ]
