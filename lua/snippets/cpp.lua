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
#define rep(i, n) for(ll i = 0; i < n; ++i)
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
    modfact[mod] = vector<ll>(size + 1, 0);
    modinvfact[mod] = vector<ll>(size + 1, 0);
    modfact[mod][0] = 1;
    for (int i = 0; i < size; ++i)
        modfact[mod][i + 1] = modfact[mod][i] * (i + 1) % mod;
    modinvfact[mod][size] = inv(modfact[mod][size], mod);
    for (int i = size - 1; i >= 0; --i)
        modinvfact[mod][i] = modinvfact[mod][i + 1] * (i + 1) % mod;
}}
ll nCr(ll n, ll r, ll mod) {{
    assert(n >= r);
    assert(n >= 0 && r >= 0);
    if (modfact.count(mod) == 0 || modfact[mod].size() <= max(n, r)) {{
        const ll size = max(500000LL, max(n, r));
        calc_fact(size, mod);
    }}
    return modfact[mod][n] * modinvfact[mod][r] % mod * modinvfact[mod][n - r] %
           mod;
}}
ll nHr(ll n, ll r, ll mod) {{
    return nCr(n + r - 1, r, mod);
}}
]],
	{}
))
table.insert(snip, combinatorics)



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
    int n;
    // G: 元のグラフ, rG: 逆辺を張ったグラフ
    vector<vector<int>> G, rG;

    // order: トポロジカルソート
    vector<int> order;

	// component: 各頂点が属する強連結成分の番号
    vector<int> component;
	// component_size: 強連結成分のサイズ
    vector<long long> components_size;
	// component_count: 強連結成分の数
	int component_count = 0;

	vector<vector<int>> rebuildedG;

	// 1度目のDFSでトポロジカルソートを行う O(|V|+|E|)
    void topological_sort() {{
        vector<bool> used(n, false);
        auto dfs = [&used, this](auto dfs, int v) -> void {{
            used[v] = 1;
            for (auto nv : G[v]) {{
                if (!used[nv]) dfs(dfs, nv);
            }}
            order.push_back(v);
        }};

        for (int v = 0; v < n; ++v) {{
            if (!used[v]) dfs(dfs, v);
        }}

        reverse(order.begin(), order.end());
    }}
	// 2度目のDFSで逆辺のグラフでトポロジカル順に強連結成分を探す O(|V|+|E|)
    void search_components() {{
        auto dfs = [this](auto dfs, int v, int k) -> void {{
            component[v] = k;
            components_size[k]++;
            for (auto nv : rG[v]) {{
                if (component[nv] == -1) dfs(dfs, nv, k);
            }}
        }};

		for (auto v : order) {{
			if (component[v] == -1) {{
				components_size.push_back(0);
				dfs(dfs, v, component_count++);
			}}
		}}
    }}
	/**
	* @brief 強連結成分を1つのノードとして扱うグラフを再構築する O(|V|+|E|)
	*/
    void rebuild() {{
		rebuildedG.resize(component_count);

        set<pair<int, int>> connected;
        for (int v = 0; v < n; v++) {{
            for (auto nv : G[v]) {{
				int v_comp = component[v];
				int nv_comp = component[nv];
				pair<int, int> p = {{v_comp, nv_comp}};
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
    SCC(vector<vector<int>> &_G)
        : n(_G.size()), G(_G), rG(vector<vector<int>>(n)), component(vector<int>(n, -1)) {{
        // 逆辺を張ったグラフを作成
        for (int v = 0; v < n; v++) {{
            for (auto nv : G[v])
                rG[nv].push_back(v);
        }}

        topological_sort();
		search_components();
		rebuild();
    }}

	vector<vector<int>> get_rebuilded_graph() const {{ return rebuildedG; }}

	size_t size() const {{ return component_count; }}
	/**
	 * @brief 強連結成分の番号を取得する
	 * @param v 頂点の番号
	 */
	int get_component(int v) const {{
		assert(0 <= v && v < n);
		return component[v];
	}}
	/**
	 * @brief 強連結成分のサイズを取得する
	 * @param component 強連結成分の番号
	 */
	long long get_component_size(int component) const {{
		assert(0 <= component && component < size());
		return components_size[component];
	}}

	/**
	 * @brief 強連結成分のグラフを取得する
	 * @remark トポロジカル順に並んでいる
	 * @param component 強連結成分の番号
	 */
	vector<int>& operator[](int component) {{
		assert(0 <= component && component < size());
		return rebuildedG[component];
	}}

	/**
	* @brief 2頂点が同じ強連結成分に属するかを判定する
	*/
    bool is_same(int u, int v) {{ return component[u] == component[v]; }}
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
        auto ext_gcd = [&](auto f, long long a, long long b, long long &x,
                           long long &y) -> long long {{
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
template <typename T> class segtree
{{
  public:
    static segtree<T> RangeMinimumQuery(int len, T e) {{
        return segtree<T>(len, e, [](T a, T b) {{ return min(a, b); }});
    }}

    static segtree<T> RangeMaximumQuery(int len, T e) {{
        return segtree<T>(len, e, [](T a, T b) {{ return max(a, b); }});
    }}

    static segtree<T> RangeSumQuery(int len, T e) {{
        return segtree<T>(len, e, [](T a, T b) {{ return a + b; }});
    }}

	static segtree<T> RangeMultiplyQuery(int len, T e) {{
		return segtree<T>(len, e, [](T a, T b) {{ return a * b; }});
	}}
	
	static segtree<T> RangeXorQuery(int len, T e) {{
		return segtree<T>(len, e, [](T a, T b) {{ return a ^ b; }});
	}}

	// 葉の数
	int length;

    /**
     * @brief セグメント木のコンストラクタ
     * @param len 配列の長さ
     * @param e 単位元（評価するときの意味のない値。MinQueryの場合、min(x, INF)のINFは意味がない）
     * @param query クエリ関数
     */
    segtree(int len, T e, function<T(T, T)> query)
        : E(e), length(1), _query(std::move(query)) {{
        // 要素数を2の冪乗にする
        while (length < len) {{
            length <<= 1;
        }}
        _data.assign(length * 2 - 1, E);
    }}

	/**
	* @remark O(1) 評価しないので、build()を呼ぶこと O(N)
	*/
    T& operator[](size_t i) {{
        if (i < 0 || i >= length) throw out_of_range("Index out of range");
        return _data[i + length - 1];
    }}

    // 構築 O(N)
    void build() {{
        for (int i = length - 2; i >= 0; --i) {{
            _data[i] = _query(_data[i * 2 + 1], _data[i * 2 + 2]);
        }}
    }}

    // 値を更新 O(log N)
    void update(int i, T value) {{
        if (i < 0 || i >= length) throw out_of_range("Index out of range");
        i += length - 1;
        _data[i] = value;
        while (i > 0) {{
            i = (i - 1) >> 1;
            _data[i] = _query(_data[i * 2 + 1], _data[i * 2 + 2]);
        }}
    }}

    // 区間クエリ [a, b) O(log N)
    T query(int a, int b) const {{
		if (a < 0 || b < 0 || a >= length || b > length) throw out_of_range("Index out of range");
		return _querySub(a, b, 0, 0, length);
	}}

  private:
    const T E;                // 単位元
    vector<T> _data;          // 完全二分木配列
    function<T(T, T)> _query; // クエリ関数

    // 区間クエリ内部処理
    T _querySub(int a, int b, int k, int l, int r) const {{
        if (r <= a || b <= l) {{ // 完全に範囲外
            return E;
        }}
        else if (a <= l && r <= b) {{ // 完全に範囲内
            return _data[k];
        }}
        else {{ // 一部重なる
            T vl = _querySub(a, b, k * 2 + 1, l, (l + r) / 2);
            T vr = _querySub(a, b, k * 2 + 2, (l + r) / 2, r);
            return _query(vl, vr);
        }}
    }}
}};
]],
	{}
))
table.insert(snip, segtree)



local trie = s("trie", fmt([[
template <int char_size, int base>
struct Trie {{
	struct Node {{
		vector<Node*> next;
		vector<int> accept;
		int c;
		int common;
		Node(int c) : c(c), common(0) {{
			next.assign(char_size, nullptr);
		}}
	}};

	vector<Node*> nodes;
	Node* root;
	Trie() : root(new Node(-1)) {{
		nodes.push_back(root);
	}}

	/**
	 * @brief 文字列sをTrie木に挿入する O(|s|)
	 * @param s 挿入する文字列
	 * @param id 挿入する文字列のID(文字列の終端のノードにIDを保存しておく)
	 */
	void insert(const string& s, int id) {{
		Node* now = root;
		now->common++;
		for (size_t i = 0; i < s.size(); ++i) {{
			int c = s[i] - base;
			if (now->next[c] == nullptr) {{
				now->next[c] = new Node(c);
				nodes.push_back(now->next[c]);
			}}
			now = now->next[c];
			now->common++;
		}}
		now->accept.push_back(id);
	}}

	/**
	 * @brief 文字列sと完全一致する文字列がTrie木にいくつあるかを返す O(|s|)
	 */
	int count(const string& s) {{
		Node* now = root;
		for (size_t i = 0; i < s.size(); ++i) {{
			int c = s[i] - base;
			if (now->next[c] == nullptr) return 0;
			now = now->next[c];
		}}
		return now->accept.size();
	}}

	/**
	 * @brief 文字列sで始まる文字列がTrie木にいくつあるかを返す O(|s|)
	 */
	int start_with(const string& s) {{
		Node* now = root;
		for (size_t i = 0; i < s.size(); ++i) {{
			int c = s[i] - base;
			if (now->next[c] == nullptr) return 0;
			now = now->next[c];
		}}
		return now->common;
	}}

	/**
	 * @brief 文字列sと共通する最長の接頭辞を返す O(|s|)
	 */
	string common_prefix(const string& s) {{
		Node* now = root;
		for (size_t i = 0; i < s.size(); ++i) {{
			int c = s[i] - base;
			if (now->next[c] == nullptr) return s.substr(0, i);
			now = now->next[c];
		}}
		return s;
	}}

	/**
	 * @brief 文字列sと共通する接頭辞を持つ文字列の個数の最大値を返す O(|s|)
	 */
	int common_prefix_max(const string& s) {{
		Node* now = root;
		int mx = 0;
		for (size_t i = 0; i < s.size(); ++i) {{
			int c = s[i] - base;
			if (now->next[c] == nullptr) return mx;
			now = now->next[c];
			mx = max(mx, now->common);
		}}
		return mx;
	}}

	/**
	 * @brief 文字列sと共通する接頭辞の合計の長さを返す O(|s|)
	 */
	int common_prefix_sum(const string& s) {{
		Node* now = root;
		int sum = 0;
		for (size_t i = 0; i < s.size(); ++i) {{
			int c = s[i] - base;
			if (now->next[c] == nullptr) return sum;
			now = now->next[c];
			sum += now->common;
		}}
		return sum;
	}}
}};
]],
	{}
))
table.insert(snip, trie)




return snip
