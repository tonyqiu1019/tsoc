#include <iostream>
#include <vector>
#include <string>
#include <unordered_map>

using namespace std;

const string types[8] = {"A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"};

unordered_map<string, vector<string> > factor;
unordered_map<string, string> match;


bool check(string f, string m, string c) {
    if (c[c.length()-1] == '+' &&
        f[f.length()-1] == '-' && m[m.length()-1] == '-') return false;

    f = f.substr(0, f.length()-1);
    m = m.substr(0, m.length()-1);
    c = c.substr(0, c.length()-1);

    for (string s1 : factor[f]) for (string s2 : factor[m])
        if (c == match[s1 + s2]) return true;
    return false;
}


int main() {
    factor["A"] = {"A", "O"};
    factor["B"] = {"B", "O"};
    factor["AB"] = {"A", "B"};
    factor["O"] = {"O"};

    match["AA"] = "A"; match["AB"] = "AB"; match["AO"] = "A";
    match["BA"] = "AB"; match["BB"] = "B"; match["BO"] = "B";
    match["OA"] = "A"; match["OB"] = "B"; match["OO"] = "O";

    string f, m, c; vector<string> possible;
    int cases = 0;

    while (true) {
        cin >> f >> m >> c; possible.clear();
        if (f == "E" && m == "N" && c == "D") break;

        if (f == "?") {
            for (int i = 0; i < 8; i++)
                if (check(types[i], m, c)) possible.push_back(types[i]);

            cout << "Case " << ++cases << ": ";
            if (possible.size() < 1) cout << "IMPOSSIBLE";
            else if (possible.size() == 1) cout << possible[0];
            else {
                cout << "{";
                for (int i = 0; i < possible.size(); i++) {
                    cout << possible[i];
                    if (i != possible.size()-1) cout << " ";
                }
                cout << "}";
            }
            cout << " " << m << " " << c << endl;
        } else if (m == "?") {
            for (int i = 0; i < 8; i++)
                if (check(f, types[i], c)) possible.push_back(types[i]);

            cout << "Case " << ++cases << ": " << f << " ";
            if (possible.size() < 1) cout << "IMPOSSIBLE";
            else if (possible.size() == 1) cout << possible[0];
            else {
                cout << "{";
                for (int i = 0; i < possible.size(); i++) {
                    cout << possible[i];
                    if (i != possible.size()-1) cout << " ";
                }
                cout << "}";
            }
            cout << " " << c << endl;
        } else {
            for (int i = 0; i < 8; i++)
                if (check(f, m, types[i])) possible.push_back(types[i]);

            cout << "Case " << ++cases << ": " << f << " " << m << " ";
            if (possible.size() < 1) cout << "IMPOSSIBLE";
            else if (possible.size() == 1) cout << possible[0];
            else {
                cout << "{";
                for (int i = 0; i < possible.size(); i++) {
                    cout << possible[i];
                    if (i != possible.size()-1) cout << " ";
                }
                cout << "}";
            }
            cout << endl;
        }
    }

    return 0;
}
