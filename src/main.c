#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#if defined AFL || defined GCOV
__AFL_FUZZ_INIT()
#endif

enum
{
	OK,
	ERROR,
};

static int	run(int argc, char *argv[], char *buf)
{
	(void)argc;
	(void)argv;

	if (buf[0] == 'a' && buf[1] == 'b' && buf[2] == 'c')
	{
		// Different EXIT_FAILURE path
		if (buf[3] == 'x')
		{
			exit(EXIT_FAILURE);
		}
		// Infinite loop
		if (buf[3] == 'y')
		{
			unsigned i = 0;
			while (1)
			{
				i++;
			}
			abort();
		}
		// Abnormal termination
		if (buf[3] == 'z')
		{
			// abort();
			exit(42);
		}
		if (buf[3] == 'a')
		{
			if (buf[4] == '1')
			{
				// TODO: Why doesn't division by 0 seem to crash the program, according to afl?
				// int a = 1 / buf[3];
				// exit(a);
				printf("%s\n", argv[42]);
				abort();
			}
			// if (buf[4] == '2')
			// {
			// 	if (buf[5] == '3')
			// 	{
			// 		if (buf[6] == '4')
			// 		{
			// 			if (buf[7] == '5')
			// 			{
			// 				abort();
			// 			}
			// 		}
			// 	}
			// }
		}
		exit(EXIT_FAILURE);
	}

	return OK;
}

int	main(int argc, char *argv[])
{
#ifdef __AFL_HAVE_MANUAL_CONTROL
  __AFL_INIT();
#endif

	unsigned char *buf;
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
