#include <assert.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#if defined AFL || defined GCOV
__AFL_FUZZ_INIT()
#endif

static void run(int argc, char *argv[], char *buf)
{
	(void)argc;
	(void)argv;

	// So x.txt doesn't take the same path as an empty file,
	// which'd result in "WARNING: Down to zero bytes"
	if (buf[0] == 'x')
	{
		exit(EXIT_FAILURE);
	}

	if (buf[0] == 'a')
	{
		if (buf[1] == 'b')
		{
			// Requires AFL_USE_UBSAN to be detected
			if (buf[2] == 'w')
			{
				char *p = NULL;
				char a = *p;
				(void)a;
			}
			// Different EXIT_FAILURE path
			if (buf[2] == 'x')
			{
				exit(EXIT_FAILURE);
			}
			// Infinite loop
			if (buf[2] == 'y')
			{
				unsigned i = 0;
				while (1)
				{
					i++;
				}
				abort();
			}
			// Abnormal termination
			if (buf[2] == 'z')
			{
				// abort();
				exit(42);
			}
			// Division by 0
			if (buf[2] == '\0')
			{
				int a = 1 / buf[2];
				exit(a);
			}
			// Deep abort()
			if (buf[2] == 'c')
			{
				if (buf[3] == 'd')
				{
					if (buf[4] == 'e')
					{
						if (buf[5] == 'f')
						{
							// This seems to be too deep for afl++ to reach in a reasonable amount of time, for some reason
							abort();
						}
						// abort();
					}
				}
			}
		}
	}
}

int main(int argc, char *argv[])
{
#ifdef __AFL_HAVE_MANUAL_CONTROL
  __AFL_INIT();
#endif

	printf("Started program\n");

	unsigned char *buf = (unsigned char *)"";
#ifdef AFL
	argc = 2;
	buf = __AFL_FUZZ_TESTCASE_BUF;
#elif defined GCOV || defined CTMIN
	argc = 2;
	buf = calloc(1024 + 1, sizeof(char));
	if (read(0, buf, 1024) == -1)
	{
		perror("read()");
		return EXIT_FAILURE;
	}
#endif

#if defined AFL || defined GCOV
	// __extension__ is necessary when using -Wpedantic
	while (__extension__ __AFL_LOOP(1000))
#endif
	{
		run(argc, argv, (char *)buf);
	}

	return EXIT_SUCCESS;
}
