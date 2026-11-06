#include <iostream>
using namespace std;

int Sum(int arr[], int size){
	int sum = 0;
	
	for(int i = 0; i < size; i++){
		sum += arr[i];
	}
	return sum;
}

int main(){
	int array[] = {12, 45, 7, 93, 28, 61, 4};
	int s = 7;
	
	cout <<"Sum of N integers: " << Sum(array,s) << endl;
	return 0;
}