#include <iostream>
using namespace std;

void LargerIntegers(int arr[], int size){
    int max1, max2;

    if(arr[0] > arr[1]){
        max1 = arr[0];
        max2 = arr[1];
    } 
    
    else {
        max1 = arr[1];
        max2 = arr[0];
    }

    for(int i = 2; i < size; i++){
        if(arr[i] > max1){
            max2 = max1;
            max1 = arr[i];
        } 
        else if(arr[i] > max2){
            max2 = arr[i];
        }
    }

    cout << "First larger integer: " << max1 << endl;
    cout << "Second larger integer: " << max2 << endl;
}

int main(){
    int array[] = {12, 45, 7, 93, 28, 61, 4};
    int n = 7;

    LargerIntegers(array, n);
    return 0;
}
