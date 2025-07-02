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

local number_theory = s("number_theory", fmt([[
/**
 * @brief 拡張ユークリッドの互除法 O(log max(a, b))
 */
ll ext_gcd(ll a, ll b, ll &x, ll &y) {{
    if (b == 0) {{
        x = 1;
        y = 0;
        return a;
    }}
    ll d = ext_gcd(b, a % b, y, x);
    y -= a / b * x;
    return d;
}}
/**
 * @brief 負に対応した mod
 */
inline ll mmod(ll a, ll mod) {{
    return (a % mod + mod) % mod;
}}
/**
 * @brief 法がmodのときのaの逆元を求める O(log mod)
 * @attention aとmodが互いに素である必要がある
 */
ll inv(ll a, ll mod) {{
    ll x, y;
    ext_gcd(a, mod, x, y);
    return mmod(x, mod);
}}

/**
 * @brief 繰り返し2乗法でaのb乗を求める O(log b)
 */ 
ll pow(ll a, ll b) {{
    ll res = 1;
    while (b > 0) {{
        if (b & 1) res = res * a;
        a = a * a;
        b >>= 1;
    }}
    return res;
}}
/**
 * @brief 繰り返し2乗法でaのb乗 % modを求める O(log b)
 * @note bが負のときはaの法がmodの時の逆元を求める
 * @attention bが負のときはa^bがmodと互いに素である必要がある
 */ 
ll pow(ll a, ll b, ll mod) {{
	bool inverse = b < 0;
	if (inverse) b = -b;
    ll res = 1;
    while (b > 0) {{
        if (b & 1) res = res * a % mod;
        a = a * a % mod;
        b >>= 1;
    }}
    return inverse ? inv(res, mod) : res;
}}
]],
	{}
))
table.insert(snip, number_theory)

local modint = s("modint", fmt([[
/** @brief 法付き整数型
 * @note デフォルトの法は998244353
 * @note long long mint::default_modを設定することでデフォルトの法を変更できる(0を設定すると998244353になる)
 */
struct mint
{{
  private:
    long long n;
    long long mod;

  public:
    static long long default_mod;

	mint() : n(0), mod(default_mod == 0 ? 998244353 : default_mod) {{}}
    mint(const mint &m) {{
        n = m.n;
        mod = m.mod;
    }}
    mint(long long n, long long mod = default_mod) {{
        if (default_mod == 0) {{
			default_mod = mod == 0 ? 998244353 : mod;
			mod = default_mod;
		}}
        assert(1 <= mod);

        this->n = (n % mod + mod) % mod;
        this->mod = mod;
    }}

	/** @brief 法がmodのときの逆元 O(log mod)
	 * @attention nとmodが互いに素である必要がある
	 */
    mint inv() const {{
        assert(gcd(n, mod) == 1);
        auto ext_gcd = [&](auto f, long long a, long long b, long long &x, long long &y) -> long long {{
            if (b == 0) {{
                x = 1;
                y = 0;
                return a;
            }}
            long long d = f(f, b, a % b, y, x);
            y -= a / b * x;
            return d;
        }};

        long long x, y;
        ext_gcd(ext_gcd, n, mod, x, y);
        return mint((x % mod + mod) % mod, mod);
    }}

	/** @brief 繰り返し2乗法でthisのexp乗 % modを求める O(log exp)
	 * @note expが負のときはthisの法がmodの時の逆元を求める
	 * @attention expが負のときはthis^expがmodと互いに素である必要がある
	 * */
    mint pow(long long exp) const {{
        bool inverse = exp < 0;
        if (inverse) exp = -exp;

		ll a = n;
        ll res = 1;
        while (exp > 0) {{
            if (exp & 1) res = res * a % mod;
            a = a * a % mod;
            exp >>= 1;
        }}
        return (inverse ? mint(res, mod).inv() : mint(res, mod));
    }}

	mint &operator=(const mint &o) {{
		n = o.n;
		mod = o.mod;
		return *this;
	}}

	mint operator+() const {{ return *this; }}
	mint operator-() const {{ return 0 - *this; }}

	mint &operator++() {{
		n++;
		if (n == mod) n = 0;
		return *this;
	}}
	mint &operator--() {{
		if (n == 0) n = mod;
		n--;
		return *this;
	}}
	mint operator++(int) {{
		mint res = *this;
		++*this;
		return res;
	}}
	mint operator--(int) {{
		mint res = *this;
		--*this;
		return res;
	}}

    mint &operator+=(const mint &o) {{
        assert(mod == o.mod);
        n += o.n;
        if (n >= mod) n -= mod;
        return *this;
    }}
    mint &operator-=(const mint &o) {{
        assert(mod == o.mod);
        n += mod - o.n;
        if (n >= mod) n -= mod;
        return *this;
    }}
    mint &operator*=(const mint &o) {{
        assert(mod == o.mod);
        n = n * o.n % mod;
        return *this;
    }}
    mint &operator/=(const mint &o) {{
        assert(mod == o.mod);
        n = n * o.inv().n % mod;
        return *this;
    }}
    friend mint operator+(const mint &a, const mint &b) {{
        return mint(a) += b;
    }}
    friend mint operator-(const mint &a, const mint &b) {{
        return mint(a) -= b;
    }}
    friend mint operator*(const mint &a, const mint &b) {{
        return mint(a) *= b;
    }}
    friend mint operator/(const mint &a, const mint &b) {{
        return mint(a) /= b;
    }}

	friend bool operator==(const mint &a, const mint &b) {{
		return a.n == b.n && a.mod == b.mod;
	}}
	friend bool operator!=(const mint &a, const mint &b) {{
		return a.n != b.n || a.mod != b.mod;
	}}

    friend ostream &operator<<(ostream &os, const mint &m) {{
        os << m.n;
        return os;
    }}
}};
long long mint::default_mod = 0;
]],
	{}
))
table.insert(snip, modint)

local eratosthenes = s("eratosthenes", fmt([[
/**
 * @brief エラトステネスの篩 O(N log log N)
 * @param n 素数を求める範囲
 * @return vector<bool> xが素数かどうか
 */
vector<bool> sieve(const ll n) {{
	vector<bool> is_prime(n + 1, true);
	is_prime[0] = is_prime[1] = false;
	for (ll i = 2; i * i <= n; ++i) {{
		if (!is_prime[i]) continue;
		for (ll j = i * i; j <= n; j += i) is_prime[j] = false;
	}}
	return is_prime;
}}

/**
 * @brief エラトステネスの篩 O(N log log N)
 * @param n 素数を求める範囲
 * @return vector<ll> 素数のリスト
 */
vector<ll> primes(const ll n) {{
	vector<bool> is_prime(n + 1, true);
	vector<ll> res;
	is_prime[0] = is_prime[1] = false;
	for (ll i = 2; i <= n; ++i) {{
		if (!is_prime[i]) continue;
		res.push_back(i);
		for (ll j = i * i; j <= n; j += i) is_prime[j] = false;
	}}
	return res;
}}
]],
	{}
))
table.insert(snip, eratosthenes)

local enum_divisors = s("enum_divisors", fmt([[
/**
 * @brief 約数列挙 O(√N)
 * @param n 約数を求める数
 * @return vector<ll> 約数のリスト
 */
vector<ll> enum_divisors(ll n) {{
	vector<ll> res;
	for (ll i = 1; i * i <= n; ++i) {{
		if (n % i == 0) {{
			res.push_back(i);
			if (i * i != n) res.push_back(n / i);
		}}
	}}
	sort(res.begin(), res.end());
	return res;
}}
]],
	{}
))
table.insert(snip, enum_divisors)

local prime_factorization = s("prime_factorization", fmt([[
/**
 * @brief 素因数分解 O(√N)
 * @param n 素因数分解する数
 * @return vector<pair<ll, ll>> 素因数とその指数のリスト
 */
vector<pair<ll, ll>> prime_factorization(ll n) {{
	vector<pair<ll, ll>> res;
	for (ll i = 2; i * i <= n; ++i) {{
		if (n % i != 0) continue;
		ll ex = 0;
		while (n % i == 0) {{
			++ex;
			n /= i;
		}}
		res.push_back({{i, ex}});
	}}
	if (n != 1) res.push_back({{n, 1}});
	return res;
}}
]],
	{}
))
table.insert(snip, prime_factorization)

local combinatorics = s("combinatorics", fmt([[
ll nCrDP[67][67];
ll nCr(ll n, ll r) {{
    assert(n < 67 && r < 67);
    assert(n >= r);
    assert(n >= 0 && r >= 0);
    if (nCrDP[n][r] != 0) return nCrDP[n][r];
    if (r == 0 || n == r) return 1;
    return nCrDP[n][r] = nCr(n - 1, r - 1) + nCr(n - 1, r);
}}
ll nHr(ll n, ll r) {{
    return nCr(n + r - 1, r);
}}

vector<ll> fact;
void calc_fact(ll size) {{
    assert(size <= 20);
    fact = vector<ll>(size + 1, 0);
    fact[0] = 1;
    for (int i = 0; i < size; ++i)
        fact[i + 1] = fact[i] * (i + 1);
}}
unordered_map<ll, vector<ll>> modfact, modinvfact;
void calc_fact(ll size, ll mod) {{
	if (modfact.count(mod) && modfact[mod].size() - 1 > size) return;

	ll oldsize = max(0, (int)modfact[mod].size() - 1);
	modfact[mod].resize(size + 1, 1);
	modinvfact[mod].resize(size + 1, 1);

    for (int i = oldsize; i < size; ++i)
        modfact[mod][i + 1] = modfact[mod][i] * (i + 1) % mod;
    modinvfact[mod][size] = inv(modfact[mod][size], mod);
    for (int i = size - 1; i >= oldsize; --i)
        modinvfact[mod][i] = modinvfact[mod][i + 1] * (i + 1) % mod;
}}
ll nCr(ll n, ll r, ll mod, ll dp_size = 500000LL) {{
    assert(n >= r);
    assert(n >= 0 && r >= 0);
	calc_fact(max(n, dp_size), mod);
    return modfact[mod][n] * modinvfact[mod][r] % mod * modinvfact[mod][n - r] % mod;
}}
ll nHr(ll n, ll r, ll mod, ll dp_size = 500000LL) {{
    return nCr(n + r - 1, r, mod, dp_size);
}}
]],
	{}
))
table.insert(snip, combinatorics)

return snip
