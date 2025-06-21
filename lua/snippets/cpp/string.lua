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
