#ifdef _WIN32


#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <process.h>
#include <stdio.h>

unsigned __stdcall   thread_func(void *arg)
{
    DWORD tid = GetCurrentThreadId();
    fprintf( stderr, "Thread: GetCurrentThreadId() = %lu\n", (unsigned long)tid);
    return 0;
}

int main(void)
{
    HANDLE hThread;
    unsigned dummyThreadId;   /* not strictly needed, but shows parameter use */

    hThread = (HANDLE)_beginthreadex(
        NULL,                  /* default security */
        0,                     /* default stack size */
        thread_func,           /* thread start routine */
        NULL,                  /* thread argument */
        0,                     /* start running immediately */
        &dummyThreadId         /* receives C runtime thread ID */
    );

    if (hThread == 0) {
        /* _beginthreadex failed */
        printf( "_beginthreadex failed, errno = %d\n", errno);
        return 1;
    }

     fprintf( stderr, "Main: dummyThreadId = %u\n", dummyThreadId);

    /* At this point, hThread is a valid thread HANDLE.
       Even if the thread exits quickly, the handle stays valid
       until we CloseHandle it. */
    DWORD winTid = GetThreadId(hThread);
    if (winTid == 0) {
        printf( "GetThreadId failed\n");
    } else {
        fprintf( stderr, "Main: GetThreadId(hThread) = %lu\n", (unsigned long)winTid);
    }

    /* Wait for the thread to finish, then close the handle */
    WaitForSingleObject(hThread, INFINITE);
    CloseHandle(hThread);

    return 0;
}

#else

int main(void)
{
   return( 0);
}
#endif