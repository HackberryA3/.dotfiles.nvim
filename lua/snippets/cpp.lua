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
using vll = vector<ll>;
using vvll = vector<vll>;
using P = pair<int, int>;
using PLL = pair<ll, ll>;
#define rep(i, n) for(ll i = 0; i < n; ++i)
#define loop(i, a, b) for(ll i = a; i <= b; ++i)
const ll INF = 1001001001001001001LL;

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

int main() {{
	{}

	return 0;
}}
]],
	{
		i(0)
	}
)
)
table.insert(snip, atcoder)



return snip
