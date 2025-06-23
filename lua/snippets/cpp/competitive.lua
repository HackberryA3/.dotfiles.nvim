local ls = require 'luasnip'
local s = ls.s
local sn = ls.sn
local t = ls.t
local i = ls.i
local f = ls.f
local c = ls.c
local d = ls.d
local fmt = require("luasnip.extras.fmt").fmt

local snip = {}


local atcoder = s("atcoder", fmt([[
#include <bits/stdc++.h>
using namespace std;
using ll = long long;
using ull = unsigned long long;
using vll = vector<ll>;
using vvll = vector<vll>;
using P = pair<int, int>;
using PP = pair<int, P>;
using PLL = pair<ll, ll>;
using PPLL = pair<ll, PLL>;
#define rep(i, n) for(ll i = 0; i < (ll)n; ++i)
#define rrep(i, n) for(ll i = n - 1; i >= 0; --i)
#define loop(i, a, b) for(ll i = a; i <= b; ++i)
#define all(v) v.begin(), v.end()
#define nC2(n) n * (n - 1) / 2
constexpr ll INF = 9009009009009009009LL;
constexpr int INF32 = 2002002002;
constexpr ll MOD = 998244353;
constexpr ll MOD107 = 1000000007;

int dx[8] = {{0, 1, 0, -1, 1, 1, -1, -1}};
int dy[8] = {{1, 0, -1, 0, 1, -1, 1, -1}};

template <class T>
inline bool chmax(T &a, const T &b) {{
	if (a < b) {{
		a = b;
		return true;
	}}
	return false;
}}
template <class T>
inline bool chmin(T &a, const T &b) {{
	if (a > b) {{
		a = b;
		return true;
	}}
	return false;
}}

template <typename Container,
          typename = std::enable_if_t<
              !std::is_same_v<Container, std::string> &&
              std::is_convertible_v<decltype(std::declval<Container>().begin()),
                                    typename Container::iterator>>>
ostream &operator<<(ostream &os, const Container &container) {{
    auto it = container.begin();
    auto end = container.end();

    if (it != end) {{
        os << *it;
        ++it;
    }}
	for (; it != end; ++it) {{
		os << " " << *it;
	}}
    return os;
}}
template <typename T>
ostream& operator<<(ostream& os, const vector<T>& v) {{
    for (size_t i = 0; i < v.size(); ++i) {{
        os << v[i];
        if (i != v.size() - 1) os << " ";
    }}
    return os;
}}
template <typename T>
ostream& operator<<(ostream& os, const vector<vector<T>>& vv) {{
	for (size_t i = 0; i < vv.size(); ++i) {{
		os << vv[i];
		if (i != vv.size() - 1) os << "\n";
    }}
    return os;
}}
template <typename T>
istream& operator>>(istream& is, vector<T>& v) {{
	assert(v.size() > 0);
	for (size_t i = 0; i < v.size(); ++i) is >> v[i];
	return is;
}}
template <typename T>
istream& operator>>(istream& is, vector<vector<T>>& vv) {{
	assert(vv.size() > 0);
	for (size_t i = 0; i < vv.size(); ++i) is >> vv[i];
	return is;
}}

struct phash {{
	template<class T1, class T2>
    inline size_t operator()(const pair<T1, T2> & p) const {{
        auto h1 = hash<T1>()(p.first);
        auto h2 = hash<T2>()(p.second);

		size_t seed = h1 + h2; 
		h1 = ((h1 >> 16) ^ h1) * 0x45d9f3b;
        h1 = ((h1 >> 16) ^ h1) * 0x45d9f3b;
        h1 = (h1 >> 16) ^ h1;
        seed ^= h1 + 0x9e3779b9 + (seed << 6) + (seed >> 2);
		h2 = ((h2 >> 16) ^ h2) * 0x45d9f3b;
        h2 = ((h2 >> 16) ^ h2) * 0x45d9f3b;
        h2 = (h2 >> 16) ^ h2;
        seed ^= h2 + 0x9e3779b9 + (seed << 6) + (seed >> 2);
        return seed;
    }}
}};





int solve() {{
	{}

	return 0;
}}

int main() {{
	cin.tie(nullptr);
	ios::sync_with_stdio(false);

	return solve();
}}
]],
	{
		i(0)
	}
))
table.insert(snip, atcoder)

local icpc = s("icpc", fmt([[
while (!solve()) {{ }}

return 0;
]], {}
))
table.insert(snip, icpc)

return snip
