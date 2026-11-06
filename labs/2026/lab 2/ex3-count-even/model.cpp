#include <iostream>
using namespace std;

int CountEvens(int arr[], int size){
	int count = 0;
	for(int i = 0; i < size; i++){
		if(arr[i]%2 == 0){
			count++;
		}
	}
	return count++;
}

int main(){
	int array[] = {12, 45, 7, 93, 28, 61, 4};
	int n = 7;
	cout <<"Number of even numbers: " << CountEvens(array,n) << endl;
	return 0;
}