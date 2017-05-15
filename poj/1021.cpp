#include <iostream>
#include <cstdlib>
#include <cstring>
#include <vector>
#include <unordered_set>

using namespace std;

class cluster {
public:
    cluster(int x, int y, bool *pts, unordered_set<int> &u) {
        minx = maxx = x; miny = maxy = y;
        dfs(x, y, pts, u);
        width = maxx - minx + 1; height = maxy - miny + 1;
        dim = width > height ? width : height;

        grid = (bool*) malloc(dim * dim * sizeof(bool));
        for (int i = 0; i < width; i++)
            for (int j = 0; j < height; j++)
                grid[i * dim + j] = pts[(i+minx) * 100 + (j+miny)];
    }

    ~cluster() { free(grid); }

    bool equal(const cluster &other) {
        if (width == other.width && height == other.height) {
            if (check(other)) return true;
            rotate(); rotate();
            if (check(other)) return true;
            flip();
            if (check(other)) return true;
            rotate(); rotate();
            if (check(other)) return true;
        }

        if (width == other.height && height == other.width) {
            rotate();
            if (check(other)) return true;
            rotate(); rotate();
            if (check(other)) return true;
            flip();
            if (check(other)) return true;
            rotate(); rotate();
            if (check(other)) return true;
        }

        return false;
    }

    void dfs(int x, int y, bool *pts, unordered_set<int> &u) {
        if (x < 0 || x >= 100 || y < 0 || y >= 100) return;
        if (!pts[x * 100 + y]) return;
        if (u.find(x * 100 + y) != u.end()) return;
        u.insert(x * 100 + y);

        if (x < minx) minx = x;
        if (x > maxx) maxx = x;
        if (y < miny) miny = y;
        if (y > maxy) maxy = y;

        dfs(x-1, y, pts, u);
        dfs(x+1, y, pts, u);
        dfs(x, y-1, pts, u);
        dfs(x, y+1, pts, u);
    }

    void rotate() {
        bool *tmp = (bool*) malloc(dim * dim * sizeof(bool));

        for (int i = 0; i < width; i++)
            for (int j = 0; j < height; j++)
                tmp[(height-1-j) * dim + i] = grid[i * dim + j];

        int mid = width; width = height; height = mid;
        free(grid); grid = tmp;
    }

    void flip() {
        bool *tmp = (bool*) malloc(dim * dim * sizeof(bool));

        for (int i = 0; i < width; i++)
            for (int j = 0; j < height; j++)
                tmp[(width-1-i) * dim + j] = grid[i * dim + j];

        free(grid); grid = tmp;
    }

    bool check(const cluster &other) {
        int count = 0;
        for (int i = 0; i < width; i++)
            for (int j = 0; j < height; j++)
                if (grid[i*dim + j] ^ other.grid[i*dim + j]) break;
                else count++;
        return count == width * height;
    }

    int width, height, dim, minx, maxx, miny, maxy;
    bool *grid;
};


int main() {
    bool pa[10000], pb[10000]; int coora[100], coorb[100];
    int n; cin >> n;
    int tmp1, tmp2, numpts;

    for (int i = 0; i < n; i++) {
        memset(pa, false, 10000 * sizeof(bool));
        memset(pb, false, 10000 * sizeof(bool));
        cin >> tmp1 >> tmp2 >> numpts;

        int x, y;
        for (int j = 0; j < numpts; j++) {
            cin >> x >> y; coora[j] = x * 100 + y; pa[coora[j]] = true;
        }
        for (int j = 0; j < numpts; j++) {
            cin >> x >> y; coorb[j] = x * 100 + y; pb[coorb[j]] = true;
        }

        vector<cluster*> ca, cb; unordered_set<int> ua, ub;
        cluster *clu;
        for (int j = 0; j < numpts; j++) {
            if (ua.find(coora[j]) != ua.end()) continue;
            clu = new cluster(coora[j] / 100, coora[j] % 100, pa, ua);
            ca.push_back(clu);
        }
        for (int j = 0; j < numpts; j++) {
            if (ub.find(coorb[j]) != ub.end()) continue;
            clu = new cluster(coorb[j] / 100, coorb[j] % 100, pb, ub);
            cb.push_back(clu);
        }

        if (ca.size() != cb.size()) { cout << "NO" << endl; continue; }

        unordered_set<int> used; int j, k;
        for (j = 0; j < ca.size(); j++) {
            for (k = 0; k < cb.size(); k++) {
                if (used.find(k) != used.end()) continue;
                if (ca[j]->equal(*cb[k])) { used.insert(k); break; }
            }
            if (k == cb.size()) break;
        }

        if (j == ca.size()) cout << "YES" << endl;
        else cout << "NO" << endl;
    }

    return 0;
}
