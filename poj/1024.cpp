#include <iostream>
#include <string>
#include <queue>
#include <unordered_set>
#include <unordered_map>
#include <algorithm>

using namespace std;

int t, w, h, m; string path;
unordered_set<int> blocked;


bool ok(int cur_x, int cur_y, int new_x, int new_y) {
    if (new_x < 0 || new_x >= 100) return false;
    if (new_y < 0 || new_y >= 100) return false;
    int wall = cur_x*1000000 + cur_y*10000 + new_x*100 + new_y;
    return blocked.find(wall) == blocked.end();
}


bool check() {
    int x = 0, y = 0;
    for (int i = 0; i < path.length(); i++) {
        if (path[i] == 'L') { if (!ok(x, y, x-1, y)) return false; x--; }
        if (path[i] == 'R') { if (!ok(x, y, x+1, y)) return false; x++; }
        if (path[i] == 'U') { if (!ok(x, y, x, y+1)) return false; y++; }
        if (path[i] == 'D') { if (!ok(x, y, x, y-1)) return false; y--; }
    }
    return (x == w-1) && (y == h-1);
}


bool bfs() {
    int visited[10000]; fill(visited, visited+10000, 99999);
    queue<int> q;

    visited[0] = 0; q.push(0);
    int count = 0;
    while (!q.empty()) {
        int cur = q.front(); q.pop();
        int x = cur / 100, y = cur % 100;
        if (visited[cur] > path.length()) break;

        if (x == w-1 && y == h-1) {
            if (visited[cur] < path.length()) return false;
            if (visited[cur] == path.length()) count++;
        }

        if (ok(x, y, x+1, y) && visited[cur+100] >= visited[cur] + 1) {
            visited[cur+100] = visited[cur] + 1;
            q.push(cur+100);
        }
        if (ok(x, y, x-1, y) && visited[cur-100] >= visited[cur] + 1) {
            visited[cur-100] = visited[cur] + 1;
            q.push(cur-100);
        }
        if (ok(x, y, x, y+1) && visited[cur+1] >= visited[cur] + 1) {
            visited[cur+1] = visited[cur] + 1;
            q.push(cur+1);
        }
        if (ok(x, y, x, y-1) && visited[cur-1] >= visited[cur] + 1) {
            visited[cur-1] = visited[cur] + 1;
            q.push(cur-1);
        }
    }

    return (count == 1) && check();
}


int main() {
    cin >> t;

    for (int i = 0; i < t; i++) {
        cin >> w >> h; cin >> path; cin >> m;

        blocked.clear();
        int x1, y1, x2, y2;
        for (int j = 0; j < m; j++) {
            cin >> x1 >> y1 >> x2 >> y2;
            blocked.insert(x1*1000000 + y1*10000 + x2*100 + y2);
            blocked.insert(x2*1000000 + y2*10000 + x1*100 + y1);
        }

        if (bfs()) cout << "CORRECT" << endl;
        else cout << "INCORRECT" << endl;
    }

    return 0;
}
