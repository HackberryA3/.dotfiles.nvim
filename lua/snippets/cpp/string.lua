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
template <class T, class Data = byte, typename T_Hash = hash<T>>
struct Trie {{
public:
	struct Node {{
		unordered_map<T, Node*, T_Hash> next;
		unordered_set<int> accept;
		T c;
		int common;
		Data data;
		Node(T c) : c(c), common(0) {{
		}}
	}};
private:
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
			if (!now->next.count(c)) throw runtime_error("The char " + to_string(c) + " of " + s + " is not found");
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
* @see https://snuke.hatenablog.com/entry/2014/12/02/235837
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

local z_algorithm = s("z_algorithm", fmt([[
/**
* @brief Z-Algorithm O(|s|)
* @return i番目の文字から始まるsの接頭辞と一致する部分文字列の長さを格納した配列
* @see https://snuke.hatenablog.com/entry/2014/12/03/214243
*/
vector<int> z_algorithm(const string& s) {{
	vector<int> res(s.size(), 0);
	res[0] = s.size();
	int i = 1, j = 0;
	while (i < s.size()) {{
		while (i+j < s.size() && s[j] == s[i+j]) ++j;
		res[i] = j;
		if (j == 0) {{ ++i; continue; }}
		int k = 1;
		while (i+k < s.size() && k+res[k] < j) res[i+k] = res[k], ++k;
		i += k; j -= k;
	}}
	return res;
}}
]],
	{}
))
table.insert(snip, z_algorithm)



local suffix_array = s("suffix_array", fmt([=[
class SuffixArray
{{
private:
	/**
	* @brief i文字目がLeft most S-type(連続するS-typeのうち、最も左にあるもの)かどうか
	*/
    bool is_lms(const vector<char> &t, int i) {{
        return i > 0 && t[i] == 's' && t[i - 1] == 'l';
    }}
	
	template <typename Iterable, typename T = typename Iterable::value_type>
    vector<int> induced_sort(const vector<char> &t, const Iterable &s, const ll k, const vector<int> &lmss) {{
        vector<int> sa(s.size(), -1);

        // 各文字がソート後に始まる位置を求める
        vector<int> bin(k + 1, 0);
        for (int i = 0; i < s.size(); ++i)
            bin[s[i] + 1]++;
        for (int i = 1; i < bin.size(); ++i)
            bin[i] += bin[i - 1];

        // LMSを、saのbinに後ろから格納
        vector<int> count(k, 0);
        for (int i = lmss.size() - 1; i >= 0; --i) {{
            T ch = s[lmss[i]];
            sa[bin[ch + 1] - 1 - count[ch]] = lmss[i];
            count[ch]++;
        }}

		// L-typeをsaのbinに前から格納(Lは必ずSの前に来る)
        count.assign(k, 0);
        for (int i = 0; i < sa.size(); ++i) {{
            if (sa[i] == -1) continue;
            if (sa[i] == 0) continue;
            if (t[sa[i] - 1] == 's') continue;
            T ch = s[sa[i] - 1];
            sa[bin[ch] + count[ch]] = sa[i] - 1;
            count[ch]++;
        }}

		// S-typeをsaのbinに後ろから格納(Sは必ずLの後に来る)
        count.assign(k, 0);
        for (int i = sa.size() - 1; i >= 0; --i) {{
            if (sa[i] == -1) continue;
            if (sa[i] == 0) continue;
            if (t[sa[i] - 1] == 'l') continue;
            T ch = s[sa[i] - 1];
            sa[bin[ch + 1] - 1 - count[ch]] = sa[i] - 1;
            count[ch]++;
        }}

        return sa;
    }}

	template <typename Iterable>
	vector<int> sa_is(const Iterable &s, const ll k) {{
		vector<char> t(s.size());
		t[s.size() - 1] = 's';
		for (int i = s.size() - 2; i >= 0; --i) {{
			// 今のSuffixと次のSuffixを比較して、辞書順で小さいなら's'、大きいなら'l'、同じなら次のSuffixと同じにする
			if (s[i] < s[i + 1]) t[i] = 's';
			else if (s[i] > s[i + 1]) t[i] = 'l';
			else t[i] = t[i + 1];
		}}

		// LMSを全て列挙
		vector<int> lmss;
		lmss.reserve(s.size());
		for (int i = 0; i < s.size(); ++i) {{
			if (is_lms(t, i)) lmss.push_back(i);
		}}

		vector<int> seed = lmss;
		// 最初はLMSの順番は不明なので、LMSの順番でsaを初期化
		vector<int> sa = induced_sort(t, s, k, seed);

		// ソートされたsaからLMSだけを取り出す
		vector<int> new_lmss;
		for (int i = 0; i < sa.size(); ++i) {{
			if (is_lms(t, sa[i])) new_lmss.push_back(sa[i]);
		}}
		sa = new_lmss;

		// LMSを比較して、同じなら同じ番号、違うなら違う番号を振る
		vector<int> nums(s.size(), -1);
		ll num = nums[sa[0]] = 0;
		for (int i = 1; i < sa.size(); ++i) {{
			int l = sa[i - 1], r = sa[i];
			bool diff = false;
			for (int d = 0; d < s.size(); ++d) {{
				if (s[l + d] != s[r + d] ||
					is_lms(t, l + d) != is_lms(t, r + d)) {{
					diff = true;
					break;
				}}
				else if (d > 0 && (is_lms(t, l + d) || is_lms(t, r + d))) {{
					break;
				}}
			}}
			if (diff) num++;
			nums[sa[i]] = num;
		}}

		// 元のLMSの順番に並び替え
		vector<int> res_nums;
		for (int pos : lmss) {{
			res_nums.push_back(nums[pos]);
		}}

		// もしLMSの種類数がLMSの数と同じでなければ、再帰的にsa_isを呼ぶ
		if (num + 1 < res_nums.size()) {{
			sa = sa_is(res_nums, num + 1);
		}}
		else {{
			// 種類数とLMSの数が同じなら、saを復元できる
			sa.resize(res_nums.size());
			for (int i = 0; i < res_nums.size(); ++i) {{
				sa[res_nums[i]] = i;
			}}
		}}

		seed.assign(sa.size(), 0);
		for (int i = 0; i < sa.size(); ++i) {{
			seed[i] = lmss[sa[i]];
		}}

		sa = induced_sort(t, s, k, seed);
		return sa;
	}}

	vector<int> result;

public:
	/**
	* @brief Suffix Arrayを構築する O(n)
	* @param s 添字アクセス可能なコンテナ
	* @param minimum sの要素の最小値 (文字なら0, 数字なら-INFなど)
	* @param k sの要素の種類数 (文字なら256, 数字なら取りうる範囲（10^9等の場合は座標圧縮してから構築）)
	*/
	template <typename Iterable, typename T = typename Iterable::value_type>
    SuffixArray(const Iterable &s, const T minimum = 0, const int k = 256) {{
        Iterable str = s;
        str.push_back(minimum);

        result = sa_is(str, k);
		result.erase(result.begin());
    }}

	size_t size() const {{
		return result.size();
	}}
	vector<int> get() const {{
		return result;
	}}
	int operator[](const int i) const {{
		return result[i];
	}}

	auto begin() const {{ return result.begin(); }}
	auto end() const {{ return result.end(); }}
}};
]=],
	{}
))
table.insert(snip, suffix_array)

local ahocorasick = s("aho_corasick", fmt([[
template <class T, typename T_Hash = hash<T>>
struct AhoCorasick {{
public:
	struct Node {{
		unordered_map<T, Node*, T_Hash> next;
		set<int> accept;
		Node* parent = nullptr;
		Node* fail = nullptr;
		T c;
		int v = -1;
		Node(T c, Node* parent, int v) : c(c), parent(parent), v(v) {{}}
	}};
private:
	int n;
	vector<Node*> nodes;
	Node* root;

	Node* make_node(T c, Node* parent) {{
		Node* node = new Node(c, parent, nodes.size());
		nodes.push_back(node);
		return node;
	}}
public:
	AhoCorasick() : n(0), nodes(vector<Node*>()), root(make_node('\0', nullptr)) {{}}

	Node* get_root() const {{
		return root;
	}}
	Node* get_node(int v) const {{
		return nodes[v];
	}}
	size_t size() const {{
		return n;
	}}
	size_t node_count() const {{
		return nodes.size();
	}}

	/**
	 * @brief 文字列sをAhoCorasickに挿入する O(|s|)
	 * @param s 挿入する文字列
	 * @param id 挿入する文字列のID(文字列の終端のノードにIDを保存しておく)
	 */
	template <class Iterable>
	void insert(const Iterable& s, int id) {{
		Node* now = root;
		for (const T& c : s) {{
			if (!now->next.count(c)) {{
				now->next[c] = make_node(c, now);;
			}}
			now = now->next[c];
		}}
		now->accept.insert(id);
		n++;
	}}

	/**
	 * @brief AhoCorasickの各ノードの失敗関数を構築する O(V)
	 */
	void build() {{
		queue<Node*> q;
		for (auto& [c, next] : root->next) {{
			next->fail = root;
			q.push(next);
		}}

		while (!q.empty()) {{
			Node* now = q.front();
			q.pop();

			for (auto& [c, next] : now->next) {{
				Node* f = now->fail;
				// 次のノードに対する失敗関数を求める
				// そのために、現在のノードの失敗関数を辿っていく
				// 現在のノード+c = 現在のノードの接尾辞+c となるノードを探す
				while (f != nullptr && !f->next.count(c)) {{
					f = f->fail;
				}}
				// もし見つからなかったら、失敗関数はroot
				if (f == nullptr) {{
					next->fail = root;
				}} else {{
					next->fail = f->next[c];
				}}

				// 失敗関数の受理状態も引き継ぐ
				for (auto id : next->fail->accept) {{
					next->accept.insert(id);
				}}
				q.push(next);
			}}
		}}

		root->fail = root;
	}}

	/**
	 * @brief 現在のノードnowから文字cに遷移した先のノードを返す O(1)
	 */
	Node* next(Node* now, const T& c) const {{
		while (now != root && !now->next.count(c)) now = now->fail;
		if (now->next.count(c)) now = now->next[c];
		return now;
	}}

	/**
	* @brief 文字列sの部分文字列があるかを調べる O(|s|)
	* @param s 調べる文字列
	*/
	template <class Iterable>
	bool match(const Iterable& s) {{
		Node* now = root;
		if (now->accept.size() > 0) return true;
		for (const T& c : s) {{
			now = next(now, c);
			if (now->accept.size() > 0) return true;
		}}
		return false;
	}}
	/**
	* @brief 文字列sの部分文字列のidを全て返す O(|s|)
	* @param s 調べる文字列
	*/
	template <class Iterable>
	set<int> substrings(const Iterable& s) {{
		set<int> res;
		Node* now = root;
		for (const T& c : s) {{
			now = next(now, c);
			for (auto id : now->accept) {{
				res.insert(id);
			}}
		}}
		return res;
	}}
}};
]],
	{}
))
table.insert(snip, ahocorasick)

return snip
