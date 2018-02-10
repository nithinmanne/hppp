#include <iostream>
#include <omp.h>
using namespace std;

int main()
{
    int id=10;
#pragma omp parallel private(id) num_threads(16)
    {
        //id = omp_get_thread_num();
        printf("%d: Hello World!\n", id);
    }
	cout<<id<<endl;
    return 0;
}
