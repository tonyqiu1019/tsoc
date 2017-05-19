#include <iostream>
#include <string>

using namespace std;


bool go(string &res, int index, long long target, int k, string pn) {
    if (index == k) return (target == 0);

    if (pn[index] == 'p') {
        if (target <= -(1<<(k-index-1))) return false;
        res += '0';
        if (go(res, index+1, target, k, pn)) return true;
        res = res.substr(0, res.length()-1);
        res += '1';
        if (go(res, index+1, target - (1<<(k-index-1)), k, pn)) return true;
        res = res.substr(0, res.length()-1);
    } else {
        if (target >= (1<<(k-index-1))) return false;
        res += '0';
        if (go(res, index+1, target, k, pn)) return true;
        res = res.substr(0, res.length()-1);
        res += '1';
        if (go(res, index+1, target + (1<<(k-index-1)), k, pn)) return true;
        res = res.substr(0, res.length()-1);
    }

    return false;
}


int main() {
    int t; cin >> t;

    for (int i = 0; i < t; i++) {
        int k; cin >> k;
        string pn; cin >> pn;
        long long target; cin >> target;
        string res = "";
        if (go(res, 0, target, k, pn)) cout << res << endl;
        else cout << "Impossible" << endl;
    }

    return 0;
}
