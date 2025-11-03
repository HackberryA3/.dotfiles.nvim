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



local linalg = s("linalg", fmt([[
constexpr double DEG2RAD = M_PI / 180.0;
constexpr double RAD2DEG = 180.0 / M_PI;

template <typename Derived, typename T>
struct vector2_base;

template <typename T>
struct matrix {{
private:
	vector<vector<T>> d;
	size_t n, m;
public:
	matrix(const matrix& o) = default;
	matrix(size_t n, size_t m, T init = T()) : d(n, vector<T>(m, init)), n(n), m(m) {{}}

	vector<T>& operator[](size_t i) {{ return d[i]; }}
	const vector<T>& operator[](size_t i) const {{ return d[i]; }}
	size_t rows() const {{ return n; }}
	size_t cols() const {{ return m; }}

	matrix& operator=(const matrix& o) {{
		if (this == &o) return *this;
		d = o.d;
		n = o.n;
		m = o.m;
		return *this;
	}}

	// --- 行列同士の演算 ---
	void calc(function<T(const T v, size_t i, size_t j)> f) {{
		for (size_t i = 0; i < n; ++i) {{
			for (size_t j = 0; j < m; ++j) {{
				d[i][j] = f(i, j);
			}}
		}}
	}}
	matrix& operator+=(const matrix& o) {{
		if (n != o.n || m != o.m) {{
			throw std::invalid_argument("行列の足し算は同じサイズでなければなりません。" + to_string(n) + "x" + to_string(m) + " != " + to_string(o.n) + "x" + to_string(o.m));
		}}
		calc([&o](T v, size_t i, size_t j) {{ return v + o[i][j]; }});
		return *this;
	}}
	matrix& operator-=(const matrix& o) {{
		if (n != o.n || m != o.m) {{
			throw std::invalid_argument("行列の引き算は同じサイズでなければなりません。" + to_string(n) + "x" + to_string(m) + " != " + to_string(o.n) + "x" + to_string(o.m));
		}}
		calc([&o](T v, size_t i, size_t j) {{ return v - o[i][j]; }});
		return *this;
	}}
	matrix& operator*=(const matrix& o) {{
		if (m != o.n) {{
			throw std::invalid_argument("行列の掛け算は、左側の列数と右側の行数が一致しなければなりません。" + to_string(m) + " != " + to_string(o.n));
		}}
		matrix<T> result(n, o.m);
		for (size_t i = 0; i < n; ++i) {{
			for (size_t j = 0; j < o.m; ++j) {{
				for (size_t k = 0; k < m; ++k) {{
					result[i][j] += d[i][k] * o.d[k][j];
				}}
			}}
		}}
		d = result.d;
		m = o.m;
		return *this;
	}}
	matrix operator+(const matrix& o) const {{ return matrix(*this) += o; }}
	matrix operator-(const matrix& o) const {{ return matrix(*this) -= o; }}
	matrix operator*(const matrix& o) const {{ return matrix(*this) *= o; }}

	bool operator==(const matrix& o) const {{
		if (n != o.n || m != o.m) return false;
		for (size_t i = 0; i < n; ++i) {{
			for (size_t j = 0; j < m; ++j) {{
				if (d[i][j] != o.d[i][j]) return false;
			}}
		}}
		return true;
	}}
	bool operator!=(const matrix& o) const {{
		return !(*this == o);
	}}

	// --- スカラー演算 ---
	matrix& operator+=(const T& s) {{
		calc([&s](T v, size_t i, size_t j) {{ return v + s; }});
		return *this;
	}}
	matrix& operator-=(const T& s) {{
		calc([&s](T v, size_t i, size_t j) {{ return v - s; }});
		return *this;
	}}
	matrix& operator*=(const T& s) {{
		calc([&s](T v, size_t i, size_t j) {{ return v * s; }});
		return *this;
	}}
	matrix& operator/=(const T& s) {{
		if (s == 0) {{
			throw std::invalid_argument("ゼロで割ることはできません。");
		}}
		calc([&s](T v, size_t i, size_t j) {{ return v / s; }});
		return *this;
	}}
	matrix operator+(const T& s) const {{ return matrix(*this) += s; }}
	matrix operator-(const T& s) const {{ return matrix(*this) -= s; }}
	matrix operator*(const T& s) const {{ return matrix(*this) *= s; }}
	matrix operator/(const T& s) const {{ return matrix(*this) /= s; }}

	// --- ベクトルとの演算 ---
	template <typename Derived, typename U>
	matrix& operator*=(const vector2_base<Derived, U>& v) {{
		matrix<T> nv(m, 1, 1);
		nv[0][0] = static_cast<T>(v.x);
		nv[1][0] = static_cast<T>(v.y);
		return (*this) *= nv;
	}}
	template <typename Derived, typename U>
	matrix operator*(const vector2_base<Derived, U>& v) const {{ return matrix(*this) *= v; }}
	template <typename Derived, typename U>
	friend matrix operator*(const vector2_base<Derived, U>& v, const matrix& mat) {{
		matrix<T> nv(1, mat.n, 1);
		nv[0][0] = static_cast<T>(v.x);
		nv[0][1] = static_cast<T>(v.y);
		return nv * mat;
	}}


	/// @brief 転置
	matrix transpose() const {{
		matrix<T> result(m, n);
		for (size_t i = 0; i < n; ++i) {{
			for (size_t j = 0; j < m; ++j) {{
				result[j][i] = d[i][j];
			}}
		}}
		return result;
	}}
	/// @brief 単位行列
	static matrix identity(size_t size) {{
		matrix<T> I(size, size, T());
		for (size_t i = 0; i < size; ++i) {{
			I[i][i] = static_cast<T>(1);
		}}
		return I;
	}}
	/// @brief 変換行列: 平行移動
	static matrix translate(T tx, T ty) {{
		matrix<T> res = identity(3);
		res[0][2] = tx;
		res[1][2] = ty;
		return res;
	}}
	/// @brief 変換行列: 回転
	static matrix rotate(double rad) {{
		matrix<T> res = identity(3);
		double c = cos(rad);
		double s = sin(rad);
		res[0][0] = static_cast<T>(c);
		res[0][1] = static_cast<T>(-s);
		res[1][0] = static_cast<T>(s);
		res[1][1] = static_cast<T>(c);
		return res;
	}}
	/// @brief 変換行列: 拡大縮小
	static matrix scale(T sx, T sy) {{
		matrix<T> res = identity(3);
		res[0][0] = sx;
		res[1][1] = sy;
		return res;
	}}
	/// @brief 変換行列: スキュー
	static matrix skew(double kx, double ky) {{
		matrix<T> res = identity(3);
		res[0][1] = static_cast<T>(tan(kx));
		res[1][0] = static_cast<T>(tan(ky));
		return res;
	}}


	friend ostream& operator<<(ostream& os, const matrix<T>& mat) {{
		for (size_t i = 0; i < mat.n; ++i) {{
			for (size_t j = 0; j < mat.m; ++j) {{
				os << mat.d[i][j];
				if (j != mat.m - 1) os << " ";
			}}
			if (i != mat.n - 1) os << "\n";
		}}
		return os;
	}}
}};

template <typename Derived, typename T>
struct vector2_base {{
    T x, y;
    vector2_base(T x = 0, T y = 0) : x(x), y(y) {{}}

	/** @brief ベクトルの長さ */
    double magnitude() const {{
        return sqrt(x * x + y * y);
    }}
	/** @brief ベクトルの長さの二乗 */
    T sqr_magnitude() const {{
        return x * x + y * y;
    }}
	/** @brief ベクトルの角度(ラジアン) */
	double radian() const {{
		return atan2(y, x);
	}}
	/** @brief ベクトルの角度(度) */
	double degree() const {{
		return radian() * RAD2DEG;
	}}

	static constexpr Derived zero() {{ return Derived(0, 0); }}
	static constexpr Derived up() {{ return Derived(0, 1); }}
	static constexpr Derived down() {{ return Derived(0, -1); }}
	static constexpr Derived left() {{ return Derived(-1, 0); }}
	static constexpr Derived right() {{ return Derived(1, 0); }}
	static constexpr Derived inf() {{ return Derived(numeric_limits<T>().max(), numeric_limits<T>().max()); }}
	static constexpr Derived neg_inf() {{ return Derived(numeric_limits<T>().min(), numeric_limits<T>().min()); }}
	/** @brief 内積 */
	static T dot(const Derived& v1, const Derived& v2) {{
		return v1.x * v2.x + v1.y * v2.y;
	}}
	/** @brief 外積 */
	static T cross(const Derived& v1, const Derived& v2) {{
		return v1.x * v2.y - v1.y * v2.x;
	}}
	/** @brief 外積 (o->p1 と o->p2 のベクトル) */
	static T cross(const Derived& o, const Derived& p1, const Derived& p2) {{
		return (p1.x - o.x) * (p2.y - o.y) - (p1.y - o.y) * (p2.x - o.x);
	}}
	/** @brief 2点間の距離 */
	static double distance(const Derived& p1, const Derived& p2) {{
		return sqrt((p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y));
	}}
	/** @brief 2点間の距離の二乗 */
	static T sqr_distance(const Derived& p1, const Derived& p2) {{
		return (p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y);
	}}
	/** @brief 2つのベクトルの角度(ラジアン) */
	static double radian(const Derived& v1, const Derived& v2) {{
		T dot_product = dot(v1, v2);
		double mag_a = v1.magnitude();
		double mag_b = v2.magnitude();
		if (mag_a == 0 || mag_b == 0) return 0;
		return acos(dot_product / (mag_a * mag_b));
	}}
	/** @brief 2つのベクトルの角度(度) */
	static double degree(const Derived& v1, const Derived& v2) {{
		return radian(v1, v2) * RAD2DEG;
	}}
	/** @brief 2つのベクトルが垂直かどうか */
	static bool is_orthogonal(const Derived& v1, const Derived& v2) {{
		return dot(v1, v2) == 0;
	}}
	/** @brief 2つのベクトルが平行かどうか */
	static bool is_parallel(const Derived& v1, const Derived& v2) {{
		return cross(v1, v2) == 0;
	}}
	/** @brief Counter Clockwise判定
	 * @return 1: p1 -> p2 -> p3 は反時計回り
	 * @return -1: p1 -> p2 -> p3 は時計回り
	 * @return 0: p1, p2, p3 は一直線上 */
	static int counter_clockwise(const Derived& p1, const Derived& p2, const Derived& p3) {{
		T cross_product = cross(p1, p2, p3);
		if (cross_product > 0) return 1;
		if (cross_product < 0) return -1;
		return 0;
	}}
	/** @brief 2つのベクトルが同じ方向を向いているかどうか */
	static bool is_same_direction(const Derived& v1, const Derived& v2) {{
		return dot(v1, v2) > 0 && cross(v1, v2) == 0;
	}}
	/** @brief 2つのベクトルが逆方向を向いているかどうか */
	static bool is_opposite_direction(const Derived& v1, const Derived& v2) {{
		return dot(v1, v2) < 0 && cross(v1, v2) == 0;
	}}
	/** @brief 点p2が直線o->p1上にあるかどうか */
	static bool is_on_segment(const Derived& o, const Derived& p1, const Derived& p2) {{
		if (counter_clockwise(o, p1, p2) != 0) return false; // 直線上にない
		return (min(o.x, p1.x) <= p2.x && p2.x <= max(o.x, p1.x)) &&
			   (min(o.y, p1.y) <= p2.y && p2.y <= max(o.y, p1.y));
	}}
	/** @brief 直線p1->p2と直線p3->p4の交差判定 */
	static bool is_intersect(const Derived& p1, const Derived& p2, const Derived& p3, const Derived& p4) {{
		int ccw1 = ccw(p1, p2, p3);
		int ccw2 = ccw(p1, p2, p4);
		int ccw3 = ccw(p3, p4, p1);
		int ccw4 = ccw(p3, p4, p2);
		if (ccw1 != ccw2 && ccw3 != ccw4) return true; // 交差している
		if (ccw1 == 0 && is_on_segment(p1, p2, p3)) return true; // p3がp1->p2上にある
		if (ccw2 == 0 && is_on_segment(p1, p2, p4)) return true; // p4がp1->p2上にある
		if (ccw3 == 0 && is_on_segment(p3, p4, p1)) return true; // p1がp3->p4上にある
		if (ccw4 == 0 && is_on_segment(p3, p4, p2)) return true; // p2がp3->p4上にある
		return false;
	}}


    Derived operator+(const Derived& o) const {{ return Derived(x + o.x, y + o.y); }}
    Derived operator-(const Derived& o) const {{ return Derived(x - o.x, y - o.y); }}
    Derived operator*(T s) const {{ return Derived(x * s, y * s); }}
    Derived operator/(T s) const {{ return Derived(x / s, y / s); }}
    Derived& operator+=(const Derived& o) {{ x += o.x; y += o.y; return static_cast<Derived&>(*this); }}
    Derived& operator-=(const Derived& o) {{ x -= o.x; y -= o.y; return static_cast<Derived&>(*this); }}
    Derived& operator*=(T s) {{ x *= s; y *= s; return static_cast<Derived&>(*this); }}
    Derived& operator/=(T s) {{ x /= s; y /= s; return static_cast<Derived&>(*this); }}
    bool operator==(const Derived& o) const {{ return x == o.x && y == o.y; }}
    bool operator!=(const Derived& o) const {{ return !(*this == o); }}

	friend istream& operator>>(istream& is, Derived& v) {{
		is >> v.x >> v.y;
		return is;
	}}
	friend ostream& operator<<(ostream& os, const Derived& v) {{
		os << v.x << " " << v.y;
		return os;
	}}

	template <typename U>
	explicit vector2_base(const matrix<U>& m) {{
		if ((m.rows() != 2 && m.rows() != 3) || m.cols() != 1) throw std::invalid_argument("vector2_base <- matrix: size mismatch");
		x = static_cast<T>(m[0][0]);
		y = static_cast<T>(m[1][0]);
	}}
	template <typename UDerived, typename U>
	explicit vector2_base(vector2_base<UDerived, U> v) {{
		x = static_cast<T>(v.x);
		y = static_cast<T>(v.y);
	}}
}};

struct int2 : public vector2_base<int2, int64_t> {{
    using vector2_base::vector2_base;

    int2 rotate90(int2 center = int2()) const {{
		int nx = x - center.x, ny = y - center.y;
		return int2(-ny + center.x, nx + center.y);
    }}
}};

struct double2 : public vector2_base<double2, double> {{
    using vector2_base::vector2_base;

    double2 rotate(double rad, double2 center = double2()) const {{
        double nx = x - center.x, ny = y - center.y;
        double cx = cos(rad), sx = sin(rad);
        return double2(nx * cx - ny * sx + center.x, nx * sx + ny * cx + center.y);
    }}
	/** @brief fromベクトル から toベクトル への射影 */
	static double2 projection(const double2& from, const double2& to) {{
		double b_sqr_magnitude = to.sqr_magnitude();
		if (b_sqr_magnitude == 0) throw std::invalid_argument("射影対象のベクトルがゼロベクトルです。");
		double scale = dot(from, to) / b_sqr_magnitude;
		return double2(to.x * scale, to.y * scale);
	}}
	/** @brief center_line_vecベクトルを中心とする直線に対して、posベクトルの反射点を求める */
	static double2 reflection(const double2& v1, const double2& center_line_v1) {{
		double2 proj = projection(v1, center_line_v1);
		return double2(2 * proj.x - v1.x, 2 * proj.y - v1.y);
	}}
	/** @brief center_line_p1, center_line_p2を通る直線に対して、点p1の反射点を求める */
	static double2 reflection(const double2& p1, const double2& center_line_p1, const double2& center_line_p2) {{
		double2 center_line_vec = center_line_p2 - center_line_p1;
		double2 v1 = p1 - center_line_p1;
		return reflection(v1, center_line_vec) + center_line_p1;
	}}
	/** @brief 直線p1->p2と直線p3->p4の交点を求める
	 * @return 交点が存在しない場合、infを返す */
	static double2 cross_point(const double2& p1, const double2& p2, const double2& p3, const double2& p4) {{
		double a1 = p2.y - p1.y;
		double b1 = p1.x - p2.x;
		double c1 = a1 * p1.x + b1 * p1.y;
		double a2 = p4.y - p3.y;
		double b2 = p3.x - p4.x;
		double c2 = a2 * p3.x + b2 * p3.y;
		double det = a1 * b2 - a2 * b1;
		if (det == 0) {{
			return inf();
		}}
		return double2((b2 * c1 - b1 * c2) / det, (a1 * c2 - a2 * c1) / det);
	}}
}};
]],
{}
))
table.insert(snip, linalg)

return snip
