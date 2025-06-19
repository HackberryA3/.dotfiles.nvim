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

// Linear Algebra ////////////////////////////////////////////////
const double Rad2Deg = 180.0 / M_PI;
const double Deg2Rad = M_PI / 180.0;
//////////////////////////////////////////////////////////////////

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



local number_theory = s("number_theory", fmt([[
/**
 * @brief 拡張ユークリッドの互除法
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
 * @brief 法がmodのときのaの逆元を求める
 * @remark aとmodが互いに素である必要がある
 */
ll inv(ll a, ll mod) {{
    ll x, y;
    ext_gcd(a, mod, x, y);
    return mmod(x, mod);
}}

ll pow(ll a, ll b) {{
    ll res = 1;
    while (b > 0) {{
        if (b & 1) res = res * a;
        a = a * a;
        b >>= 1;
    }}
    return res;
}}
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



local offset_vector = s("offset_vector", fmt([[
template <typename T>
struct offset_vector {{
	vector<T> data;
	const int offset;

	/** @brief 負のインデックスをサポートするベクトル
	 * @param n 正のインデックスのサイズ
	 * @param offset 負のインデックスに拡張する数
	 * @param init_val 初期値（デフォルトはT()）
	 */
	offset_vector(int n, int offset = 0, T init_val = T()) : offset(offset) {{
		assert(0 <= n && "offset_vectorの初期化時のnは0以上でなければなりません");
		assert(0 <= offset && "offset_vectorの初期化時のoffsetは0以上でなければなりません");
		data.resize(n + offset, init_val);
	}}

	T& operator[](int i) {{
		assert(0 <= i + offset && "offset_vectorへの負方向の範囲外参照です");
		assert(i + offset < data.size() && "offset_vectorへの正方向の範囲外参照です");
		return data[i + offset];
	}}

	auto begin() {{
		return data.begin();
	}}
	auto end() {{
		return data.end();
	}}
	auto rbegin() {{
		return data.rbegin();
	}}
	auto rend() {{
		return data.rend();
	}}
	auto size() const {{
		return data.size();
	}}
	size_t positive_size() const {{
		return data.size() - offset;
	}}
	auto empty() const {{
		return data.empty();
	}}
	auto front() {{
		assert(!data.empty() && "offset_vectorが空です");
		return data.front();
	}}
	auto back() {{
		assert(!data.empty() && "offset_vectorが空です");
		return data.back();
	}}

	void push_back(const T& value) {{
		data.push_back(value);
	}}
	void pop_back() {{
		assert(offset < data.size() && "offset_vectorのpop_backは、負の要素に対しては使用できません");
		assert(!data.empty() && "offset_vectorのpop_backは、空のベクトルに対しては使用できません");
		data.pop_back();
	}}

	friend ostream& operator<<(ostream& os, const offset_vector<T>& v) {{
		for (size_t i = 0; i < v.size(); ++i) {{
			if (i != 0) os << " ";
			os << v.data[i];
		}}
		os << "\n";
		return os;
	}}
}};
]],
	{}
))
table.insert(snip, offset_vector)

local linked_list = s("linked_list", fmt([[
template <class T, typename Hash = hash<T>> class LinkedList
{{
  public:
    struct Node
    {{
        T val;
        Node *next;
        Node *prev;
        Node(T val) : val(val) {{}}
    }};

    Node *head;
    Node *tail;

  private:
    unordered_map<T, unordered_set<Node *>, Hash> mp;
    size_t length;

  public:
    LinkedList() {{
        head = nullptr;
        tail = nullptr;
    }}
    size_t size() {{ return length; }}

	/** 
	* @brief valの値を持つNodeの先頭を返す O(1)
	* @param val 検索する値
	* @return Node* valの値を持つNodeの先頭
	* @return nullptr valの値を持つNodeが存在しない場合
	*/
    Node *first(T val) {{
        if (mp[val].empty()) return nullptr;
        return *mp[val].begin();
    }}
	/**
	* @brief valの値を持つNodeの末尾を返す O(1)
	* @param val 検索する値
	* @return Node* valの値を持つNodeの末尾
	* @return nullptr valの値を持つNodeが存在しない場合
	*/
    Node *last(T val) {{
        if (mp[val].empty()) return nullptr;
        return *mp[val].rbegin();
    }}
	/**
	* @brief valの値を持つNodeの集合を返す O(1)
	* @param val 検索する値
	* @return unordered_set<Node*> valの値を持つNodeの集合
	*/
    unordered_set<Node *> find(T val) {{ return mp[val]; }}

	/**
	* @brief nodeの後ろにvalの値を持つNodeを挿入する O(1)
	* @param val 挿入する値
	* @param node 挿入する位置のNode
	* @return Node* 挿入されたNode
	*/
    Node *insertAfter(T val, Node *node) {{
        Node *new_node = new Node(val);
        length++;
        mp[val].insert(new_node);

        if (node == nullptr) {{
            assert(head == nullptr);
            assert(tail == nullptr);
            head = tail = new_node;
            return new_node;
        }}
        new_node->next = node->next;
        new_node->prev = node;
        node->next = new_node;
        if (new_node->next == nullptr) tail = new_node;
        else new_node->next->prev = new_node;
        return new_node;
    }}
	/**
	* @brief idx番目のNodeの後ろにvalの値を持つNodeを挿入する O(N / 2)
	* @param val 挿入する値
	* @param idx 挿入する位置のインデックス
	* @return Node* 挿入されたNode
	*/
    Node *insertAfter(T val, int idx) {{
		assert(0 <= idx && idx < length);
        if (length / 2 >= idx) {{
            Node *node = head;
            rep(i, idx) {{
                assert(node != nullptr);
                node = node->next;
            }}
            return insertAfter(val, node);
        }}
        else {{
            Node *node = tail;
            rep(i, length - idx - 1) {{
                assert(node != nullptr);
                node = node->prev;
            }}
            return insertAfter(val, node);
        }}
    }}
	/**
	* @brief nodeの前にvalの値を持つNodeを挿入する O(1)
	* @param val 挿入する値
	* @param node 挿入する位置のNode
	* @return Node* 挿入されたNode
	*/
    Node *insertBefore(T val, Node *node) {{
        Node *new_node = new Node(val);
        length++;
        mp[val].insert(new_node);

        if (node == nullptr) {{
            assert(head == nullptr);
            assert(tail == nullptr);
            head = tail = new_node;
            return new_node;
        }}
        new_node->next = node;
        new_node->prev = node->prev;
        node->prev = new_node;

        if (new_node->prev == nullptr) head = new_node;
        else new_node->prev->next = new_node;
        return new_node;
    }}
	/**
	* @brief idx番目のNodeの前にvalの値を持つNodeを挿入する O(N / 2)
	* @param val 挿入する値
	* @param idx 挿入する位置のインデックス
	* @return Node* 挿入されたNode
	*/
    Node *insertBefore(T val, int idx) {{
        if (length / 2 >= idx) {{
            Node *node = head;
            rep(i, idx) {{
                assert(node != nullptr);
                node = node->next;
            }}
            return insertBefore(val, node);
        }}
        else {{
            Node *node = tail;
            rep(i, length - idx - 1) {{
                assert(node != nullptr);
                node = node->prev;
            }}
            return insertBefore(val, node);
        }}
    }}
    Node *push_front(T val) {{ return insertBefore(val, head); }}
    Node *push_back(T val) {{ return insertAfter(val, tail); }}
	/**
	* @brief nodeを削除する O(1)
	* @param node 削除するNode
	*/
    void erase(Node *node) {{
        length--;
        mp[node->val].erase(node);

        if (node->prev == nullptr) head = node->next;
        else node->prev->next = node->next;
        if (node->next == nullptr) tail = node->prev;
        else node->next->prev = node->prev;
        delete node;
    }}
	/**
	* @brief idx番目のNodeを削除する O(N / 2)
	* @param idx 削除する位置のインデックス
	*/
    void erase(int idx) {{
        if (length / 2 >= idx) {{
            Node *node = head;
            rep(i, idx) {{
                assert(node != nullptr);
                node = node->next;
            }}
            erase(node);
        }}
        else {{
            Node *node = tail;
            rep(i, length - idx - 1) {{
                assert(node != nullptr);
                node = node->prev;
            }}
            erase(node);
        }}
    }}
    T pop_front() {{
        T val = head->val;
        erase(head);
        return val;
    }}
    T pop_back() {{
        T val = tail->val;
        erase(tail);
        return val;
    }}

	/**
	* @brief LinkedListをクリアする O(N)
	*/
	void clear() {{
		while (head) {{
			Node *node = head;
			head = head->next;
			delete node;
		}}
		tail = nullptr;
		length = 0;
		mp.clear();
	}}

    class iterator
    {{
      private:
        Node *current;

      public:
        using iterator_category = std::bidirectional_iterator_tag;
        using value_type = T;
        using difference_type = std::ptrdiff_t;
        using pointer = T *;
        using reference = T &;

        iterator(Node *node) : current(node) {{}}

        T &operator*() {{ return current->val; }}

        iterator &operator++() {{
            if (current) current = current->next;
            return *this;
        }}
        iterator operator++(int) {{
            iterator temp = *this;
            if (current) current = current->next;
            return temp;
        }}
        iterator &operator--() {{
            if (current) current = current->prev;
            return *this;
        }}
        iterator operator--(int) {{
            iterator temp = *this;
            if (current) current = current->prev;
            return temp;
        }}

        bool operator==(const iterator &other) const {{
            return current == other.current;
        }}
        bool operator!=(const iterator &other) const {{
            return current != other.current;
        }}
    }};

    iterator begin() const {{ return iterator(head); }}
    iterator end() const {{ return iterator(nullptr); }}
    iterator rbegin() const {{ return iterator(tail); }}
    iterator rend() const {{ return iterator(nullptr); }}
    Node *front() const {{ return head; }}
    Node *back() const {{ return tail; }}
}};
]],
	{}
))
table.insert(snip, linked_list)





local graph = s("graph", fmt([[
template <class T> struct Edge
{{
    int from;
    int to;
    T val;

	Edge() : from(-1), to(-1), val(T()) {{}}
	Edge(const int& i) : from(-1), to(i), val(T()) {{}} 
	Edge(int from, int to) : from(from), to(to), val(T()) {{}}
	Edge(int from, int to, T val) : from(from), to(to), val(val) {{}}
	bool operator==(const Edge &e) const {{ return from == e.from && to == e.to && val == e.val; }}
	bool operator!=(const Edge &e) const {{ return from != e.from || to != e.to || val != e.val; }}
	bool operator<(const Edge &e) const {{ return val < e.val; }}
	bool operator>(const Edge &e) const {{ return val > e.val; }}
	bool operator<=(const Edge &e) const {{ return val <= e.val; }}
	bool operator>=(const Edge &e) const {{ return val >= e.val; }}

	operator int() const {{ return to; }}

	friend ostream& operator << (ostream& os, const Edge& e) {{
		os << e.from << " -> " << e.to << " : " << e.val;
		return os;
	}}
}};
template <class T> using Graph = vector<vector<Edge<T>>>;

template <class T>
vector<vector<T>> inverseGraph(const vector<vector<T>>& G) {{
	vector<vector<T>> rG(G.size());
	rep(i, G.size()) for (const T& e : G[i]) rG[e].push_back(i);
	return rG;
}}
template <class T>
vector<vector<Edge<T>>> inverseGraph(const vector<vector<Edge<T>>>& G) {{
	vector<vector<Edge<T>>> rG(G.size());
	rep(i, G.size()) for (const Edge<T>& e : G[i]) rG[e.to].push_back(Edge<T>(e.to, e.from, e.val));
	return rG;
}}
]],
	{}
))
table.insert(snip, graph)



local bfs = s("bfs", fmt([[
vll dist({n}, INF);
queue<int> q;
q.push({start});
dist[{start}] = 0;

while (!q.empty()) {{
	ll now = q.front();
	q.pop();

	{visit}

	for (const int& next : {graph}[now]) {{
		if (dist[next] != INF) continue;
		dist[next] = dist[now] + 1;
		q.push(next);

		{found}
	}}
}}
]],
	{
		n = i(1, "n"),
		start = i(2, "s"),
		visit = i(3, "// On visit"),
		graph = i(4, "graph"),
		found = i(5, "// On found")
	},
	{
		repeat_duplicates = true
	}
))
table.insert(snip, bfs)



local bfs_grid = s("bfs_grid", fmt([[
vector<vector<ll>> dist({h}, vector<ll>({w}, INF));
queue<P> q;
q.push({start});
dist[q.front().first][q.front().second] = 0;

while(!q.empty()) {{
	auto [y, x] = q.front();
	q.pop();

	{visit}{}

	rep(i, 4) {{
		int nx = x + dx[i];
		int ny = y + dy[i];
		if (nx < 0 || {w} <= nx || ny < 0 || {h} <= ny) continue;
		if (dist[ny][nx] != INF) continue;
		dist[ny][nx] = dist[y][x] + 1;
		q.push({{ny, nx}});

		{found}
	}}
}}
]],
	{
		h = i(1, "h"),
		w = i(2, "w"),
		start = i(3, "s"),
		visit = i(4, "// On visit"),
		found = i(5, "// On found"),
		i(0)
	},
	{
		repeat_duplicates = true
	}
))
table.insert(snip, bfs_grid)



local dijkstra = s("dijkstra", fmt([[
struct DijkstraResult {{
	vector<ll> dist;
	vector<int> prev;

	DijkstraResult(const vector<ll>& dist, const vector<int>& prev) : dist(dist), prev(prev) {{}}

	ll operator[](const int i) const {{ return dist[i]; }}
	operator size_t() const {{ return dist.size(); }}

	/**
	 * @brief スタート地点からgoalまでの経路を復元する O(E)
	 * @param goal 経路復元したいノード 
	 * @return vector<long long> スタート地点からgoalまでの経路
	*/
	vector<int> restore(const int goal) const {{
		vector<int> path;
		for (int now = goal; now != -1; now = prev[now]) path.push_back(now);
		reverse(path.begin(), path.end());
		return path;
	}}
}};

/**
 * @brief グラフの最短経路を求める O(|E| log |V|)
 * @remark コストに負の値があるときは使えない
 * @remark 全ての辺がコスト1の場合はBFSで求まる
 * @param G 隣接リスト
 * @param start スタート地点のノード番号
 * @return DijkstraGridResult dist[x] にスタート地点からxまでの最短距離が格納される @n restore(long long goal)で経路復元できる
*/
template <class T>
DijkstraResult dijkstra(const vector<vector<Edge<T>>> &G, const int start, const T inf) {{
	vector<T> dist(G.size(), inf);
	vector<int> prev(G.size(), -1);
	priority_queue<PLL, vector<PLL>, greater<PLL>> q;
	q.push({{0, start}});
	dist[start] = 0;

	while (!q.empty()) {{
		auto [nowCost, now] = q.top();
		q.pop();
		if (dist[now] < nowCost) continue;

		{visit}{}

		for (const Edge<T>& e : G[now]) {{
			if (dist[e.to] <= dist[now] + e.val) continue;
			dist[e.to] = dist[now] + e.val;
			prev[e.to] = now;
			q.push({{dist[e.to], e.to}});

			{found}
		}}
	}}

	return DijkstraResult(dist, prev);
}}
]],
	{
		visit = i(1, "// On visit"),
		found = i(2, "// On found"),
		i(0)
	},
	{
		repeat_duplicates = true
	}
))
table.insert(snip, dijkstra)



local dijkstra_grid = s("dijkstra_grid", fmt([[
struct DijkstraGridResult {{
	vector<vector<ll>> dist;
	vector<vector<P>> prev;

	DijkstraGridResult(const vector<vector<ll>>& dist, const vector<vector<P>>& prev) : dist(dist), prev(prev) {{}}

	vector<ll> operator[](const int i) const {{ return dist[i]; }}
	operator size_t() const {{ return dist.size(); }}

	/**
	 * @brief スタート地点からgoalまでの経路を復元する O(4HW)
	 * @param goal 経路復元したい座標 
	 * @return vector<pair<int, int>> スタート地点からgoalまでの経路
	*/
	vector<P> restore(const P goal) const {{
		vector<P> path;
		for (P now = goal; now != P(-1, -1); now = prev[now.first][now.second]) path.push_back(now);
		reverse(path.begin(), path.end());
		return path;
	}}
}};

/**
 * @brief グリッド上の最短経路を求める O(4HW log(HW))
 * @remark コストに負の値があるときは使えない
 * @remark 最大1000*1000のグリッドでO(2 * 10^7)程度
 * @param grid 隣のマスからのコストが格納されたグリッド
 * @param sy スタート地点のy座標
 * @param sx スタート地点のx座標
 * @return dist[y][x] にスタート地点から(y, x)までの最短距離が格納される @n restore(pair<int, int> goal)で経路復元できる
*/
DijkstraGridResult dijkstra(const vector<vector<ll>> &grid, int sy, int sx) {{
	vector<vector<ll>> dist(grid.size(), vector<ll>(grid[0].size(), INF));
	vector<vector<P>> prev(grid.size(), vector<P>(grid[0].size(), P(-1, -1)));
	priority_queue<PPLL, vector<PPLL>, greater<PPLL>> q;
	q.push({{0, {{sy, sx}}}});
	dist[sy][sx] = 0;

	while (!q.empty()) {{
		auto [nowCost, pos] = q.top();
		auto [y, x] = pos;
		q.pop();
		if (dist[y][x] < nowCost) continue;

		{visit}{}

		rep(i, 4) {{
			ll nx = x + dx[i];
			ll ny = y + dy[i];
			if (nx < 0 || grid[0].size() <= nx || ny < 0 || grid.size() <= ny) continue;
			if (dist[ny][nx] <= nowCost + grid[ny][nx]) continue;
			dist[ny][nx] = nowCost + grid[ny][nx];
			prev[ny][nx] = pos;
			q.push({{dist[ny][nx], {{ny, nx}}}});

			{found}
		}}
	}}

	return DijkstraGridResult(dist, prev);
}}
]],
	{
		visit = i(1, "// On visit"),
		found = i(2, "// On found"),
		i(0)
	},
	{
		repeat_duplicates = true
	}
))
table.insert(snip, dijkstra_grid)



local topological_sort = s("topological_sort", fmt([[
/**
* @brief トポロジカルソートO(V + E)
* @details 有向グラフの依存関係を考慮したソート
* @remark グラフが有向非巡回グラフ(DAG)の場合のみ使用可能
* @remark queueをpriority_queueに変えると、辞書順最小/最大のトポロジカルソートが得られる
* @remark 特定の頂点への最短経路を求める場合は、向きを反転したグラフに、その頂点から帰りがけ順にDFSをする
* @param graph 隣接リスト
* @return トポロジカルソートされた頂点番号 (閉路があった場合は空のvectorを返す)
*/
template <class T>
vector<int> topologicalSort(const vector<vector<T>>& graph) {{
	vector<int> result;
	vector<int> in(graph.size(), 0);

	for(const auto& v : graph) {{
		for(const int& to : v) {{
			in[to]++;
		}}
	}}

	queue<int> q;
	for (int i = 0; i < in.size(); ++i) {{
		if (in[i] == 0) q.push(i);
	}}

	while (!q.empty()) {{
		int v = q.front(); q.pop();
		result.push_back(v);

		for (const int& to : graph[v]) {{
			if (--in[to] == 0) q.push(to);
		}}
	}}

	return result.size() == graph.size() ? result : vector<int>();
}}
]],
	{}
))
table.insert(snip, topological_sort)



local union_find = s("union_find", fmt([[
class UnionFind
{{
  private:
    ll _size;
    vector<ll> _parent;

  public:
    UnionFind(ll size) {{
        _size = size;
        _parent.resize(_size, -1);
    }}

    ll root(ll x) {{
        if (_parent[x] < 0) return x;
        else return _parent[x] = root(_parent[x]);
    }}

    void unite(ll x, ll y) {{
        x = root(x);
        y = root(y);
        if (x != y) {{
            if (-_parent[x] < -_parent[y]) swap(x, y);
            _parent[x] += _parent[y];
            _parent[y] = x;
        }}
    }}

    bool isSame(ll x, ll y) {{ return root(x) == root(y); }}

    ll size(ll x) {{ return -_parent[root(x)]; }}

    vector<vector<ll>> groups() {{
        vector<vector<ll>> member(_size);
        for (ll i = 0; i < _size; ++i) {{
            member[root(i)].push_back(i);
        }}

        vector<vector<ll>> result;
        for (ll i = 0; i < _size; ++i) {{
            if (!member[i].empty()) result.push_back(member[i]);
        }}

        return result;
    }}
}};
]],
	{}
))
table.insert(snip, union_find)



local cycle_detection = s("cycle_detection", fmt([[
/** 
* @brief グラフのサイクル検出 O(V + E)
* @details 最初に見つけたサイクルを返す
* @param G 隣接リスト(Edge<T>にfromを設定する必要がある)
* @param directional 逆流を許すか(無向グラフの場合はfalse)
* @param all 全ての頂点から探索を開始するか
* @param start 探索を開始する頂点
* @return サイクルの辺のリスト
*/
template <class T>
vector<Edge<T>> detect_cycle(const Graph<T> &G, const bool directional = true, const bool all = true, const int start = 0) {{
	vector<bool> seen(G.size(), false), finished(G.size(), false);
	stack<Edge<T>> history;

	auto dfs = [&](const auto dfs, const int v, const Edge<T> e) -> int {{
		seen[v] = true; // たどり着いた
		history.push(e);
		
		for(const Edge<T> next : G[v]) {{
			// 無向グラフの場合、逆流を禁止する
			if (!directional && next.to == e.from) continue;
			if (finished[next.to]) continue;
			// １回たどり着いた頂点に再度たどり着いた場合、サイクルが検出される
			if (seen[next.to] && !finished[next.to]) {{
				history.push(next);
				return next.to;
			}}

			int pos = dfs(dfs, next.to, next);
			if (pos != -1) return pos;
		}}

		finished[v] = true; // 完全に見終わった
		history.pop();
		return -1;
	}};

	auto restore = [&](const int pos) -> vector<Edge<T>> {{
		vector<Edge<T>> cycle;
		// 履歴を、同じ頂点まで遡る
		while (!history.empty()) {{
			const Edge<T> e = history.top();
			cycle.push_back(e);
			history.pop();
			if (e.from == pos) break;
		}}
		reverse(cycle.begin(), cycle.end());
		return cycle;
	}};

	// start から探索を開始
	int pos = -1;
	pos = dfs(dfs, start, Edge<T>());
	if (pos != -1) return restore(pos);

	// all が true の場合、全ての頂点から探索を開始
	if (all) {{
		for (int v = 0; v < (int)G.size(); ++v) {{
			if (seen[v]) continue;
			history = stack<Edge<T>>();
			pos = dfs(dfs, v, Edge<T>());
			if (pos != -1) return restore(pos);
		}}
	}}

	// サイクルが見つからなかった場合
	return vector<Edge<T>>();
}}
]],
	{}
))
table.insert(snip, cycle_detection)

local scc = s("scc", fmt([[
/**
 * @brief 強連結成分分解(Strongly Connected Components)
 */
struct SCC
{{
  private:
    // 元の頂点数
    long long n;
    // G: 元のグラフ, rG: 逆辺を張ったグラフ
    vector<vector<long long>> G, rG;

    // order: トポロジカルソート
    vector<long long> order;

	// component: 各頂点が属する強連結成分の番号
    vector<long long> component;
	// component_size: 強連結成分のサイズ
    vector<long long> components_size;
	// component_count: 強連結成分の数
	long long component_count = 0;
	// component_elements: 各強連結成分に属する頂点のリスト
	vector<vector<long long>> component_elements;

	vector<vector<long long>> rebuildedG;

	// 1度目のDFSでトポロジカルソートを行う O(|V|+|E|)
    void topological_sort() {{
        vector<bool> used(n, false);
        auto dfs = [&used, this](auto dfs, long long v) -> void {{
            used[v] = 1;
            for (auto nv : G[v]) {{
                if (!used[nv]) dfs(dfs, nv);
            }}
            order.push_back(v);
        }};

        for (long long v = 0; v < n; ++v) {{
            if (!used[v]) dfs(dfs, v);
        }}

        reverse(order.begin(), order.end());
    }}
	// 2度目のDFSで逆辺のグラフでトポロジカル順に強連結成分を探す O(|V|+|E|)
    void search_components() {{
        auto dfs = [this](auto dfs, long long v, long long k) -> void {{
            component[v] = k;
            components_size[k]++;
			component_elements[k].push_back(v);
            for (auto nv : rG[v]) {{
                if (component[nv] == -1) dfs(dfs, nv, k);
            }}
        }};

		for (auto v : order) {{
			if (component[v] == -1) {{
				components_size.push_back(0);
				component_elements.push_back(vector<long long>());
				dfs(dfs, v, component_count++);
			}}
		}}
    }}
	/**
	* @brief 強連結成分を1つのノードとして扱うグラフを再構築する O(|V|+|E|)
	*/
    void rebuild() {{
		rebuildedG.resize(component_count);

        set<pair<long long, long long>> connected;
        for (long long v = 0; v < n; v++) {{
            for (auto nv : G[v]) {{
				long long v_comp = component[v];
				long long nv_comp = component[nv];
				pair<long long, long long> p = {{v_comp, nv_comp}};
                if (!is_same(v, nv) &&
                    !connected.count(p)) {{
                    rebuildedG[v_comp].push_back(nv_comp);
					connected.insert(p);
                }}
            }}
        }}
    }}

  public:
	/**
	 * @brief 強連結成分分解を行う O(3 * |V|+|E|)
	 */
    SCC(vector<vector<long long>> &_G) : n(_G.size()), G(_G), rG(vector<vector<long long>>(n)), component(vector<long long>(n, -1)) {{
        // 逆辺を張ったグラフを作成
        for (long long v = 0; v < n; v++) {{
            for (auto nv : G[v])
                rG[nv].push_back(v);
        }}

        topological_sort();
		search_components();
		rebuild();
    }}

	size_t size() const {{ return component_count; }}
	/**
	 * @brief 強連結成分の番号を取得する
	 * @param v 頂点の番号
	 */
	long long get_component(long long v) const {{
		assert(0 <= v && v < n);
		return component[v];
	}}
	/**
	 * @brief 強連結成分のサイズを取得する
	 * @param component 強連結成分の番号
	 */
	long long get_component_size(long long component) const {{
		assert(0 <= component && component < size());
		return components_size[component];
	}}
	/**
	 * @brief 強連結成分に属する頂点のリストを取得する
	 * @param component 強連結成分の番号
	 */
	vector<long long> get_component_elements(long long component) const {{
		assert(0 <= component && component < size());
		return component_elements[component];
	}}

	/**
	 * @brief 強連結成分のグラフを取得する
	 * @remark トポロジカル順に並んでいる
	 * @param component 強連結成分の番号
	 */
	vector<long long>& operator[](long long component) {{
		assert(0 <= component && component < size());
		return rebuildedG[component];
	}}
	// 暗黙的なvector<vector<long long>>への変換
	operator vector<vector<long long>>() const {{ return rebuildedG; }}

	/**
	* @brief 2頂点が同じ強連結成分に属するかを判定する
	*/
    bool is_same(long long u, long long v) {{ return component[u] == component[v]; }}
}};
]],
	{}
))
table.insert(snip, scc)



local modint = s("modint", fmt([[
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



local segtree = s("segtree", fmt([[
template <typename T>
class segtree
{{
  protected:
    const T E;                      // 単位元
    vector<T> _data;                // 完全二分木配列
    const function<T(T, T)> _query; // クエリ関数
    int _length;                    // 葉の数

    T _query_sub(int a, int b, int k, int l, int r) const {{
        if (r <= a || b <= l) {{ // 完全に範囲外
            return E;
        }}
        else if (a <= l && r <= b) {{ // 完全に範囲内
            return _data[k];
        }}
        else {{ // 一部重なる
            T vl = _query_sub(a, b, k * 2 + 1, l, (l + r) / 2);
            T vr = _query_sub(a, b, k * 2 + 2, (l + r) / 2, r);
            return _query(vl, vr);
        }}
    }}

  public:
    /**
     * @brief セグメント木
     * @param len 配列の長さ
     * @param e 単位元（評価するときの意味のない値。MinQueryの場合、min(x,
     * INF)のINFは意味がない）
     * @param query クエリ関数
     */
    segtree(int len, T e, function<T(T, T)> query) : E(e), _query(std::move(query)), _length(1) {{
        // 要素数を2の冪乗にする
        while (_length < len) {{
            _length <<= 1;
        }}
        _data.assign(_length * 2 - 1, E);
    }}

    size_t size() const {{ return _length; }}

    /**
     * @remark O(1) 評価しないので、build()を呼ぶこと O(N)
     */
    T &operator[](size_t i) {{
        if (i < 0 || i >= _length) throw out_of_range("Index out of range");
        return _data[i + _length - 1];
    }}

    /**
     * @brief 構築 O(N)
     */
    void build() {{
        for (int i = _length - 2; i >= 0; --i) {{
            _data[i] = _query(_data[i * 2 + 1], _data[i * 2 + 2]);
        }}
    }}

    /**
     * @brief 更新 O(log N)
     */
    void update(int i, T value) {{
        if (i < 0 || i >= _length) throw out_of_range("Index out of range");
        i += _length - 1;
        _data[i] = value;
        while (i > 0) {{
            i = (i - 1) >> 1;
            _data[i] = _query(_data[i * 2 + 1], _data[i * 2 + 2]);
        }}
    }}

    /**
     * @brief 区間クエリ [a, b) O(log N)
     */
    T query(int a, int b) const {{
        if (a < 0 || b < 0 || a >= _length || b > _length)
            throw out_of_range("Index out of range");
        return _query_sub(a, b, 0, 0, _length);
    }}

    static segtree<T> RangeMinimumQuery(int len, T e = numeric_limits<T>::max()) {{
        return segtree<T>(len, e, [](T a, T b) {{ return min(a, b); }});
    }}

    static segtree<T> RangeMaximumQuery(int len, T e = numeric_limits<T>::min()) {{
        return segtree<T>(len, e, [](T a, T b) {{ return max(a, b); }});
    }}

    static segtree<T> RangeSumQuery(int len, T e = 0) {{
        return segtree<T>(len, e, [](T a, T b) {{ return a + b; }});
    }}

    static segtree<T> RangeProductQuery(int len, T e = 1) {{
        return segtree<T>(len, e, [](T a, T b) {{ return a * b; }});
    }}

    static segtree<T> RangeXorQuery(int len, T e = 0) {{
        return segtree<T>(len, e, [](T a, T b) {{ return a ^ b; }});
    }}
}};
]],
	{}
))
table.insert(snip, segtree)

local lazy_segtree = s("lazy_segtree", fmt([[
template <typename T> 
class lazy_segtree : public segtree<T>
{{
  private:
    vector<T> _lazy;

    // lazyを子のlazyに伝播させる関数
    const function<T(T, T)> _merge;
    // lazyをdataに適用する関数
    const function<T(T, T)> _apply;
    // lazyをdataに適用する時に、区間の長さに応じて値を変える関数
    const function<T(T, int)> _proportion;
    // lazyの単位元
    const T ME;

    void _eval(int k, int len) {{
        if (_lazy[k] == ME) return;
        if (k < this->_length - 1) {{
            _lazy[k * 2 + 1] = _merge(_lazy[k * 2 + 1], _lazy[k]);
            _lazy[k * 2 + 2] = _merge(_lazy[k * 2 + 2], _lazy[k]);
        }}
        this->_data[k] = _apply(this->_data[k], _proportion(_lazy[k], len));
        _lazy[k] = ME;
    }}

    void _update_core(int a, int b, T x, int k, int l, int r) {{
        _eval(k, r - l);
        if (a <= l && r <= b) {{
            _lazy[k] = _merge(_lazy[k], x);
            _eval(k, r - l);
        }}
        else if (a < r && l < b) {{
            _update_core(a, b, x, k * 2 + 1, l, (l + r) / 2);
            _update_core(a, b, x, k * 2 + 2, (l + r) / 2, r);
            this->_data[k] = this->_query(this->_data[k * 2 + 1], this->_data[k * 2 + 2]);
        }}
    }}

    T _query_core(int a, int b, int k, int l, int r) {{
        _eval(k, r - l);
        if (r <= a || b <= l) {{ return this->E; }}
        else if (a <= l && r <= b) {{ return this->_data[k]; }}
        else {{
            T vl = _query_core(a, b, k * 2 + 1, l, (l + r) / 2);
            T vr = _query_core(a, b, k * 2 + 2, (l + r) / 2, r);
            return this->_query(vl, vr);
        }}
    }}

  public:
    /**
     * @brief 遅延セグメント木
     * @param len 配列の長さ
     * @param e 単位元
     * @param queryFunc クエリ関数
     * @param mergeFunc lazyを子のlazyに伝播させる関数
     * @param applyFunc lazyをdataに適用する関数
     * @param proportionFunc
     * lazyをdataに適用する時に、区間の長さに応じて値を変える関数
     * @param me lazyの単位元
     */
    lazy_segtree(int len, T e, function<T(T, T)> queryFunc, function<T(T, T)> mergeFunc, function<T(T, T)> applyFunc, function<T(T, int)> proportionFunc, T me)
        : segtree<T>(len, e, queryFunc), _merge(mergeFunc), _apply(applyFunc), _proportion(proportionFunc), ME(me) {{
        _lazy.assign(2 * this->_length - 1, ME);
    }}

	/**
	 * @brief ランダムアクセス O(log N)
	 */
	T& operator[](size_t i) {{
		if (i < 0 || i >= this->_length) throw out_of_range("Index out of range");
		query(i, i + 1);
		return this->_data[i + this->_length - 1];
	}}

	using segtree<T>::update;
    /**
     * @brief [a, b) 区間更新 O(log N)
     */
    void update(int a, int b, T x) {{
        _update_core(a, b, x, 0, 0, this->_length);
    }}

    /**
     * @brief 区間クエリ [a, b) O(log N)
     */
    T query(int a, int b) {{ return _query_core(a, b, 0, 0, this->_length); }}

    static lazy_segtree<T> RangeUpdateMinimumQuery(int len, T e = numeric_limits<T>::max()) {{
        return lazy_segtree<T>(
            len,
			e,
			[](T a, T b) {{ return min(a, b); }},
            [](T a, T b) {{ return b; }},
			[](T a, T b) {{ return b; }},
            [](T a, int b) {{ return a; }},
			numeric_limits<T>::max());
    }}
    static lazy_segtree<T> RangeUpdateMaximumQuery(int len, T e = numeric_limits<T>::min()) {{
        return lazy_segtree<T>(
            len,
			e,
			[](T a, T b) {{ return max(a, b); }},
            [](T a, T b) {{ return b; }},
			[](T a, T b) {{ return b; }},
            [](T a, int b) {{ return a; }},
			numeric_limits<T>::min());
    }}
    static lazy_segtree<T> RangeUpdateSumQuery(int len, T e = 0) {{
        return lazy_segtree<T>(
            len,
			e,
			[](T a, T b) {{ return a + b; }},
			[](T a, T b) {{ return b; }},
            [](T a, T b) {{ return b; }},
			[](T a, int b) {{ return a * b; }},
			0);
    }}

    static lazy_segtree<T> RangeAddMinimumQuery(int len, T e = numeric_limits<T>::max()) {{
        return lazy_segtree<T>(
            len,
			e,
			[](T a, T b) {{ return min(a, b); }},
            [](T a, T b) {{ return a + b; }},
			[](T a, T b) {{ return a + b; }},
            [](T a, int b) {{ return a; }},
			0);
    }}
    static lazy_segtree<T> RangeAddMaximumQuery(int len, T e = numeric_limits<T>::min()) {{
        return lazy_segtree<T>(
            len,
			e,
			[](T a, T b) {{ return max(a, b); }},
            [](T a, T b) {{ return a + b; }},
			[](T a, T b) {{ return a + b; }},
            [](T a, int b) {{ return a; }},
			0);
    }}
    static lazy_segtree<T> RangeAddSumQuery(int len, T e = 0) {{
        return lazy_segtree<T>(
            len,
			e,
			[](T a, T b) {{ return a + b; }},
            [](T a, T b) {{ return a + b; }},
			[](T a, T b) {{ return a + b; }},
            [](T a, int b) {{ return a * b; }},
			0);
    }}
}};

struct S
{{
    ll sum;
    ll minimum;
    ll maximum;

    S() : sum(0), minimum(9009009009009009009LL), maximum(-9009009009009009009LL) {{}}
    S(ll sum, ll minimum, ll maximum) : sum(sum), minimum(minimum), maximum(maximum) {{}}

    static S query(S a, S b) {{
        return S(a.sum + b.sum, min(a.minimum, b.minimum), max(a.maximum, b.maximum));
    }}
    static S update_merge(S a, S b) {{ return S(b.sum, b.minimum, b.maximum); }}
    static S add_merge(S a, S b) {{
        return S(a.sum + b.sum, a.minimum + b.minimum, a.maximum + b.maximum);
    }}
    static S update_apply(S a, S b) {{ return S(b.sum, b.minimum, b.maximum); }}
    static S add_apply(S a, S b) {{
        return S(a.sum + b.sum, a.minimum + b.minimum, a.maximum + b.maximum);
    }}
    static S proportion(S a, int b) {{
        return S(a.sum * b, a.minimum, a.maximum);
    }}

    static S update_identity() {{ return S(0, INF, -INF); }}
    static S add_identity() {{ return S(0, 0, 0); }}

    static lazy_segtree<S> RangeUpdateQuery(int len) {{
        return lazy_segtree<S>(len, S(), S::query, S::update_merge, S::update_apply, S::proportion, S::update_identity());
    }}

    static lazy_segtree<S> RangeAddQuery(int len) {{
        return lazy_segtree<S>(len, S(), S::query, S::add_merge, S::add_apply, S::proportion, S::add_identity());
    }}

	bool operator==(const S &rhs) const {{
		return sum == rhs.sum && minimum == rhs.minimum && maximum == rhs.maximum;
	}}
}};
]],
	{}
))
table.insert(snip, lazy_segtree)



local trie = s("trie", fmt([[
template <class T, typename T_Hash = hash<T>>
struct Trie {{
private:
	struct Node {{
		unordered_map<T, Node*, T_Hash> next;
		unordered_set<int> accept;
		T c;
		int common;
		Node(T c) : c(c), common(0) {{
		}}
	}};

	Node* root;
	int n;

public:
	Trie() : root(new Node(-1)), n(0) {{
	}}

	/**
	 * @brief 文字列sをTrie木に挿入する O(|s|)
	 * @param s 挿入する文字列
	 * @param id 挿入する文字列のID(文字列の終端のノードにIDを保存しておく)
	 */
	template <class Iterable>
	void insert(const Iterable& s, int id) {{
		Node* now = root;
		now->common++;
		for (const T& c : s) {{
			if (!now->next.count(c)) {{
				now->next[c] = new Node(c);
			}}
			now = now->next[c];
			now->common++;
		}}
		now->accept.insert(id);
		n++;
	}}
	/**
	 * @brief 文字列sをTrie木から削除する O(|s|)
	 * @param s 削除する文字列
	 */
	template <class Iterable>
	void erase(const Iterable& s) {{
		int count = this->count(s);

		Node* now = root;
		now->common -= count;
		for (const T& c : s) {{
			if (!now->next.count(c)) return;
			now = now->next[c];
			now->common -= count;
		}}
		now->accept.clear();
		n -= count;
	}}

	/**
	 * @brief 文字列sと完全一致する文字列がTrie木にいくつあるかを返す O(|s|)
	 */
	template <class Iterable>
	int count(const Iterable& s) {{
		Node* now = root;
		for (const T& c : s) {{
			if (!now->next.count(c)) return 0;
			now = now->next[c];
		}}
		return now->accept.size();
	}}
	Node get_root() const {{
		return *root;
	}}
	size_t size() const {{
		return n;
	}}

	/**
	 * @brief 文字列s分ノードを辿る O(|s|)
	 */
	template <class Iterable>
	Node get(const Iterable& s) {{
		Node* now = root;
		for (const T& c : s) {{
			if (!now->next.count(c)) throw runtime_error("The char " + c + " of " + s + " is not found");
			now = now->next[c];
		}}
		return *now;
	}}
	/**
	 * @brief 文字列s分、startからノードを辿る O(|s|)
	 */
	template <class Iterable>
	Node get(const Iterable& s, Node start) {{
		Node* now = start;
		for (const T& c : s) {{
			if (!now->next.count(c)) throw runtime_error("The char " + c + " of " + s + " is not found");
			now = now->next[c];
		}}
		return *now;
	}}

	/**
	 * @brief 文字列sで始まる文字列がTrie木にいくつあるかを返す O(|s|)
	 */
	template <class Iterable>
	int start_with(const Iterable& s) {{
		Node* now = root;
		for (const T& c : s) {{
			if (!now->next.count(c)) return 0;
			now = now->next[c];
		}}
		return now->common;
	}}

	/**
	 * @brief 文字列sで始まる文字列を削除 最悪O(全ての文字列の長さの総和)
	 */
	template <class Iterable>
	void erase_start_with(const Iterable& s) {{
		vector<Node*> history;

		Node* now = root;
		history.push_back(now);
		for (const T& c : s) {{
			if (!now->next.count(c)) return;
			now = now->next[c];
			history.push_back(now);
		}}

		int deletedCnt = 0;
		auto dfs = [&](auto self, Node* now) -> void {{
			n -= now->accept.size();
			deletedCnt += now->accept.size();

			now->common = 0;
			now->accept.clear();

			for (auto& [c, next] : now->next) {{
				self(self, next);
			}}
		}};
		dfs(dfs, now);

		while (history.size() > 0) {{
			Node* now = history.back();
			now->common -= deletedCnt;
			history.pop_back();
		}}
	}}

	/**
	 * @brief 文字列sと共通する最長の接頭辞を返す O(|s|)
	 */
	template <class Iterable>
	vector<T> common_prefix(const Iterable& s) {{
		vector<T> res;

		Node* now = root;
		for (const T& c : s) {{
			if (!now->next.count(c)) return res;
			res.push_back(c);
			now = now->next[c];
		}}
		return res;
	}}

	/**
	 * @brief 文字列sと共通する接頭辞を持つ文字列の個数の最大値を返す O(|s|)
	 */
	template <class Iterable>
	int common_prefix_max(const Iterable& s) {{
		Node* now = root;
		int mx = 0;
		for (const T& c : s) {{
			if (!now->next.count(c)) return mx;
			now = now->next[c];
			mx = max(mx, now->common);
		}}
		return mx;
	}}

	/**
	 * @brief 文字列sと共通する接頭辞の合計の長さを返す O(|s|)
	 */
	template <class Iterable>
	int common_prefix_sum(const Iterable& s) {{
		Node* now = root;
		int sum = 0;
		for (const T& c : s) {{
			if (!now->next.count(c)) return sum;
			now = now->next[c];
			sum += now->common;
		}}
		return sum;
	}}

	/**
	* @brief 文字列sの接頭辞がTrie木にいくつあるかを返す O(|s|)
	*/
	template <class Iterable>
	int prefix_count(const Iterable& s) {{
		Node* now = root;
		int cnt = 0;
		for (const T& c : s) {{
			if (!now->next.count(c)) return cnt;
			now = now->next[c];
			cnt += now->accept.size();
		}}
		return cnt;
	}}
}};
]],
	{}
))
table.insert(snip, trie)



local rolling_hash = s("rolling_hash", fmt([[
template <typename T>
struct RollingHash {{
private:
	vector<unsigned long long> pow_bases;
	vector<unsigned long long> hashes;
	vector<unsigned long long> pow_bases2;
	vector<unsigned long long> hashes2;
public:
	unsigned long long base;
	unsigned long long base2;
	static const unsigned long long mod = 2147483647;

	static unsigned long long generate_base() {{
		mt19937 rnd(chrono::steady_clock::now().time_since_epoch().count());
		return uniform_int_distribution<unsigned long long>(1, mod - 1)(rnd);
	}}

	/**
	* @brief Iterable<T>のローリングハッシュを計算する O(n)
	* @param s 文字列やvectorなどの添字アクセス可能なオブジェクト
	* @param base ハッシュの基数。デフォルトはランダムに生成される
	* @param base2 2つ目のハッシュの基数。デフォルトは-1で、使用しない
	*/
	template <typename Iterable>
	RollingHash(Iterable s, unsigned long long base = generate_base(), unsigned long long base2 = -1): pow_bases(s.size() + 1, 1), hashes(s.size() + 1, 0), base(base), base2(base2) {{
		if (base2 != -1) {{
			pow_bases2.resize(s.size() + 1, 1);
			hashes2.resize(s.size() + 1, 0);
		}}
		for (int i = 0; i < s.size(); ++i){{
			hashes[i + 1] = ((hashes[i] * base) % mod + (unsigned long long)s[i]) % mod;
			pow_bases[i + 1] = (pow_bases[i] * base) % mod;
			if (base2 != -1) {{
				hashes2[i + 1] = ((hashes2[i] * base2) % mod + (unsigned long long)s[i]) % mod;
				pow_bases2[i + 1] = (pow_bases2[i] * base2) % mod;
			}}
		}}
	}}

	/**
	* @brief [l, r) の連続部分列のハッシュ値を返す O(1)
	*/
	long long get(int l, int r) {{
		unsigned long long hash1 = (hashes[r] - (hashes[l] * pow_bases[r - l]) % mod + mod) % mod;
		unsigned long long hash2 = 0;
		if (base2 != -1) {{
			hash2 = (hashes2[r] - (hashes2[l] * pow_bases2[r - l]) % mod + mod) % mod;
		}}
		return (hash1 << 32) | hash2;
	}}
}};
]],
	{}
))
table.insert(snip, rolling_hash)



local manacher = s("manacher", fmt([[
/**
* @brief Manacher O(|s|)
* @return i番目の文字を中心とした回文の長さを格納した配列
*/
vector<long long> manacher(const string s) {{
	vector<long long> res(s.size(), 0);

	int i = 0, j = 0;
	while (i < s.size()) {{
	  while (0 <= i-j && i+j < s.size() && s[i-j] == s[i+j]) ++j;
	  res[i] = j;
	  int k = 1;
	  while (0 <= i-k && k+res[i-k] < j) res[i+k] = res[i-k], ++k;
	  i += k; j -= k;
	}}
	
	return res;
}}
]],
	{}
))
table.insert(snip, manacher)




return snip
