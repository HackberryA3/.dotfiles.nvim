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



local trie = s("trie", fmt([[
/**
 * @brief Trie木
 */
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
	vector<int64_t> pow_bases;
	vector<int64_t> hashes;
	vector<int64_t> inv_bases;
	vector<int64_t> rev_hashes;

	int64_t ext_gcd(int64_t a, int64_t b, int64_t &x, int64_t &y) {{
		if (b == 0) {{
			x = 1;
			y = 0;
			return a;
		}}
		int64_t d = ext_gcd(b, a % b, y, x);
		y -= a / b * x;
		return d;
	}}
	int64_t inv(int64_t a, int64_t mod) {{
		int64_t x, y;
		ext_gcd(a, mod, x, y);
		return (x % mod + mod) % mod;
	}}

	int64_t mul(int64_t a, int64_t b) {{
		__int128 res = a;
		res *= b;
		res %= mod;
		return (int64_t)res;
	}}

public:
	const int64_t base;
	const int64_t inv_base = 0;
	static const int64_t mod = (1LL << 61) - 1;

	static int64_t generate_base() {{
		mt19937_64 rnd(chrono::steady_clock::now().time_since_epoch().count());
		return uniform_int_distribution<int64_t>(1, mod - 1)(rnd);
	}}

	/**
	 * @brief ローリングハッシュのコンストラクタ O(1)
	 * @param base ハッシュの基数。デフォルトはランダムに生成される
	 * @param use_rev 逆方向のハッシュを計算するかどうか。デフォルトはtrue
	 * @param inv_base 逆方向のハッシュを計算する際の基数の逆元。use_revがtrueでinv_baseが0の場合、自動的に計算される O(log)
	 */
	RollingHash(int64_t base = generate_base(), bool use_rev = true, int64_t inv_base = 0): base(base), inv_base(use_rev && inv_base == 0 ? inv(base, mod) : inv_base) {{
		assert(1 <= base && base < mod && "ローリングハッシュの基数は1以上mod未満でなければなりません");

		pow_bases.push_back(1);
		hashes.push_back(0);
		if (use_rev) {{
			inv_bases.push_back(1);
			rev_hashes.push_back(0);
		}}
	}}
	/**
	* @brief Iterable<T>のローリングハッシュを計算する O(n)
	* @param s 文字列やvectorなどの添字アクセス可能なオブジェクト
	* @param base ハッシュの基数。デフォルトはランダムに生成される
	* @param use_rev 逆方向のハッシュを計算するかどうか。デフォルトはtrue
	* @param inv_base 逆方向のハッシュを計算する際の基数の逆元。use_revがtrueでinv_baseが0の場合、自動的に計算される O(log)
	*/
	template <typename Iterable>
	RollingHash(Iterable s, int64_t base = generate_base(), bool use_rev = true, int64_t inv_base = 0): RollingHash(base, use_rev, inv_base) {{
		pow_bases.reserve(s.size() + 1);
		hashes.reserve(s.size() + 1);
		if (use_rev) {{
			inv_bases.reserve(s.size() + 1);
			rev_hashes.reserve(s.size() + 1);
		}}
		for (int i = 0; i < static_cast<int>(s.size()); ++i){{
			push_back(s[i]);
		}}
	}}

	void push_back(T c) {{
		// hashes[i] = (hashes[i - 1] * base + (unsigned int64_t)c) % mod;
		// 順方向は重みが軽い方に追加。123 -> 123
		hashes.push_back((mul(hashes.back(), base) + (int64_t)c) % mod);
		if (pow_bases.size() < hashes.size()) pow_bases.push_back(mul(pow_bases.back(), base));

		// rev_hashes[i] = (base^i * c + rev_hashes[i - 1]) % mod;
		// 逆方向は重みが重い方に追加。123 -> 321
		if (inv_base != 0) {{
			rev_hashes.push_back((mul(pow_bases[rev_hashes.size() - 1], (int64_t)c) + rev_hashes.back()) % mod);
			if (inv_bases.size() < rev_hashes.size()) inv_bases.push_back(mul(inv_bases.back(), inv_base));
		}}
	}}
	void pop_back() {{
		assert(1 < (int)hashes.size() && "空のローリングハッシュから要素を削除することはできません");
		hashes.pop_back();
		if (rev_hashes.size() > 1) rev_hashes.pop_back();
	}}

	size_t size() const {{
		return hashes.size() - 1;
	}}

	/**
	* @brief [l, r) の連続部分列のハッシュ値を返す O(1)
	*/
	int64_t get(int l, int r) {{
		assert(0 <= l && l < r && r <= (int)hashes.size() - 1 && "ローリングハッシュのgetは0 <= l < r <= size()でなければなりません");
		// 123の23を取り出したい場合、123 - 1 * base^2
		int64_t hash = (hashes[r] - mul(hashes[l], pow_bases[r - l]) % mod + mod) % mod;
		return hash;
	}}
	/**
	* @brief [l, r) の連続部分列の逆方向のハッシュ値を返す O(1)
	*/
	int64_t get_rev(int l, int r) {{
		assert(0 <= l && l < r && r <= (int)rev_hashes.size() - 1 && "ローリングハッシュのget_revは0 <= l < r <= size()でなければなりません");
		// 321の32を取り出したい場合、(321 - 1) / base^2 = (321 - 1) * inv_base^2
		int64_t hash = mul((rev_hashes[r] - rev_hashes[l] + mod) % mod, inv_bases[l]);
		return hash;
	}}
	/**
	* @brief [l, r) の連続部分列が回文かどうかを判定する O(1)
	*/
	bool is_palindrome(int l, int r) {{
		assert(0 <= l && l < r && r <= (int)hashes.size() - 1 && "ローリングハッシュのis_palindromeは0 <= l < r <= size()でなければなりません");
		return get(l, r) == get_rev(l, r);
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
