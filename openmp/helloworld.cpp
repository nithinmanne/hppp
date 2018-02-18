#include <iostream>
#include <omp.h>
using namespace std;

int main()
{
    int id;
#pragma omp parallel private(id)
    {
        id = omp_get_thread_num();
        printf("%d: Hello World!\n", id);
    }
	cout<<id<<endl;
    return 0;
}
