int main() {
    int array[32];
    int i;
    for (i = 0; i < 32; i++) {
        array[i] = i;
    }

    int result = 0;
    for (i = 0; i < 32; i++) {
        result += array[i];
    }
    //printf("Result: %d\n", result);
    if (result == 496) {
        printf("RESULT: PASS\n");
    } else {
        printf("RESULT: FAIL\n");
    }

    return result;
}