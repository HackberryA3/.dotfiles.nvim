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



local offset_vector = s("offset_vector", fmt([[
/** @brief 負のインデックスをサポートするベクトル*/
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
/** @brief 双方向連結リスト
 * @tparam T 値の型
 * @tparam Hash ハッシュ関数の型（デフォルトはstd::hash<T>）
 * @details 特定の値を持つノードをO(1)で検索できるように、unordered_map<T, unordered_set<Node *>, Hash>でノードを管理。
 */
template <class T, typename Hash = hash<T>>
class LinkedList
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
     * @param proportionFunc lazyをdataに適用する時に、区間の長さに応じて値を変える関数
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

/** @brief 遅延セグメント木のMax, Min, Sumクエリをまとめた構造体 */
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

return snip
