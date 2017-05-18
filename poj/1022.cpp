#include <iostream>
#include <unordered_map>

using namespace std;


bool check(unordered_map<int, int> &dim, int last, int first) {
    int tmp = first;
    while (dim.find(tmp) != dim.end()) tmp = dim[tmp];
    return tmp == last;
}


bool go(int id, int x, int y, unordered_map<int, int> &dim,
    int &last, int &first)
{
    if (x != 0) {
        if (dim.find(x) == dim.end()) { dim[x] = id; first = x; }
        else if (dim[x] != id) return false;
    }
    if (y != 0) {
        if (dim.find(id) == dim.end()) { dim[id] = y; first = id; }
        else if (dim[id] != y) return false;
        if (dim.find(y) == dim.end()) last = y;
    }
    return true;
}


int main() {
    int t; cin >> t; bool ok;

    for (int i = 0; i < t; i++) {
        ok = true;
        int n, id, x, y, max1, min1, max2, min2, max3, min3, max4, min4;
        unordered_map<int, int> x1, x2, x3, x4;
        cin >> n;

        for (int j = 0; j < n; j++) {
            cin >> id;
            cin >> x >> y;
            if (!go(id, x, y, x1, max1, min1)) { ok = false; break; }
            cin >> x >> y;
            if (!go(id, x, y, x2, max2, min2)) { ok = false; break; }
            cin >> x >> y;
            if (!go(id, x, y, x3, max3, min3)) { ok = false; break; }
            cin >> x >> y;
            if (!go(id, x, y, x4, max4, min4)) { ok = false; break; }
        }

        ok = ok && check(x1, max1, min1) && check(x2, max2, min2)
            && check(x3, max3, min3) && check(x4, max4, min4);

        if (0) cout << "Inconsistent" << endl;
        else cout << ((x1.size()+1) * (x2.size()+1) * (x3.size()+1)
            * (x4.size()+1)) << endl;
    }

    return 0;
}
