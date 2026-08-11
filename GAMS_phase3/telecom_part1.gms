* ==========================================================
* Telecom Staff Scheduling (GAMS) - all 3 notebook parts
* ==========================================================

Sets
    h   "hours"     /h0*h23/
    j   "companies" /c1*c2/
    peak(h) "hours 7..17 (inclusive)"
    off(h)  "hours 0..6 and 18..23"
    Q(h,h)  "coverage mapping: for each demand hour, staffed start hours in 6-hour window";

Alias (h,i,k);

* Subsets for objective weights (ord(h0)=1)
peak(h) = yes$(ord(h) >= 8 and ord(h) <= 18);   
off(h)  = yes$(ord(h) <= 7 or ord(h) >= 19);    

Parameters
    cost(h)        "cost per operator starting at hour"
    demand(h,j)    "demand by hour and company"
    capHour(h)     "RHS for per-hour starting cap"
    capTotal(h)    "RHS for total active cap per demand hour"
    minCov(h)      "minimum coverage per demand hour"
    maxShort(h,j)  "max shortage per hour/company"
    totShort(j)    "total shortage cap by company";

* --- Default RHS values (so we can vary them later in part 3)
capHour(h) = 100;
capTotal(h)= 420;
minCov(h)  = 80;
maxShort(h,j) = 10;
totShort('c1') = 40;
totShort('c2') = 30;

* Costs (hour 0..23)
cost('h0')  = 189;  cost('h1')  = 189;  cost('h2')  = 189;  cost('h3')  = 180;
cost('h4')  = 171;  cost('h5')  = 162;  cost('h6')  = 153;  cost('h7')  = 144;
cost('h8')  = 135;  cost('h9')  = 126;  cost('h10') = 126;  cost('h11') = 135;
cost('h12') = 144;  cost('h13') = 153;  cost('h14') = 162;  cost('h15') = 171;
cost('h16') = 180;  cost('h17') = 189;  cost('h18') = 189;  cost('h19') = 189;
cost('h20') = 189;  cost('h21') = 189;  cost('h22') = 189;  cost('h23') = 189;

* Demand (hour, company)
* Company 1
demand('h0','c1')  = 120; demand('h1','c1')  = 95;  demand('h2','c1')  = 90;  demand('h3','c1')  = 50;
demand('h4','c1')  = 30;  demand('h5','c1')  = 30;  demand('h6','c1')  = 60;  demand('h7','c1')  = 110;
demand('h8','c1')  = 140; demand('h9','c1')  = 200; demand('h10','c1') = 180; demand('h11','c1') = 180;
demand('h12','c1') = 240; demand('h13','c1') = 220; demand('h14','c1') = 220; demand('h15','c1') = 230;
demand('h16','c1') = 250; demand('h17','c1') = 260; demand('h18','c1') = 230; demand('h19','c1') = 250;
demand('h20','c1') = 260; demand('h21','c1') = 250; demand('h22','c1') = 220; demand('h23','c1') = 190;

* Company 2
demand('h0','c2')  = 70;  demand('h1','c2')  = 40;  demand('h2','c2')  = 20;  demand('h3','c2')  = 30;
demand('h4','c2')  = 50;  demand('h5','c2')  = 40;  demand('h6','c2')  = 40;  demand('h7','c2')  = 90;
demand('h8','c2')  = 110; demand('h9','c2')  = 110; demand('h10','c2') = 110; demand('h11','c2') = 130;
demand('h12','c2') = 150; demand('h13','c2') = 160; demand('h14','c2') = 120; demand('h15','c2') = 130;
demand('h16','c2') = 160; demand('h17','c2') = 180; demand('h18','c2') = 200; demand('h19','c2') = 170;
demand('h20','c2') = 140; demand('h21','c2') = 110; demand('h22','c2') = 100; demand('h23','c2') = 90;

* Coverage mapping Q(i,k): 6-hour cyclic window (wraps around midnight)
Q('h0','h18')=yes; Q('h0','h19')=yes; Q('h0','h20')=yes; Q('h0','h22')=yes; Q('h0','h23')=yes; Q('h0','h0')=yes;
Q('h1','h19')=yes; Q('h1','h20')=yes; Q('h1','h21')=yes; Q('h1','h23')=yes; Q('h1','h0')=yes;  Q('h1','h1')=yes;
Q('h2','h20')=yes; Q('h2','h21')=yes; Q('h2','h22')=yes; Q('h2','h0')=yes;  Q('h2','h1')=yes;  Q('h2','h2')=yes;
Q('h3','h21')=yes; Q('h3','h22')=yes; Q('h3','h23')=yes; Q('h3','h1')=yes;  Q('h3','h2')=yes;  Q('h3','h3')=yes;
Q('h4','h22')=yes; Q('h4','h23')=yes; Q('h4','h0')=yes;  Q('h4','h2')=yes;  Q('h4','h3')=yes;  Q('h4','h4')=yes;
Q('h5','h23')=yes; Q('h5','h0')=yes;  Q('h5','h1')=yes;  Q('h5','h3')=yes;  Q('h5','h4')=yes;  Q('h5','h5')=yes;
Q('h6','h0')=yes;  Q('h6','h1')=yes;  Q('h6','h2')=yes;  Q('h6','h4')=yes;  Q('h6','h5')=yes;  Q('h6','h6')=yes;
Q('h7','h1')=yes;  Q('h7','h2')=yes;  Q('h7','h3')=yes;  Q('h7','h5')=yes;  Q('h7','h6')=yes;  Q('h7','h7')=yes;
Q('h8','h2')=yes;  Q('h8','h3')=yes;  Q('h8','h4')=yes;  Q('h8','h6')=yes;  Q('h8','h7')=yes;  Q('h8','h8')=yes;
Q('h9','h3')=yes;  Q('h9','h4')=yes;  Q('h9','h5')=yes;  Q('h9','h7')=yes;  Q('h9','h8')=yes;  Q('h9','h9')=yes;
Q('h10','h4')=yes; Q('h10','h5')=yes; Q('h10','h6')=yes; Q('h10','h8')=yes; Q('h10','h9')=yes; Q('h10','h10')=yes;
Q('h11','h5')=yes; Q('h11','h6')=yes; Q('h11','h7')=yes; Q('h11','h9')=yes; Q('h11','h10')=yes;Q('h11','h11')=yes;
Q('h12','h6')=yes; Q('h12','h7')=yes; Q('h12','h8')=yes; Q('h12','h10')=yes;Q('h12','h11')=yes;Q('h12','h12')=yes;
Q('h13','h7')=yes; Q('h13','h8')=yes; Q('h13','h9')=yes; Q('h13','h11')=yes;Q('h13','h12')=yes;Q('h13','h13')=yes;
Q('h14','h8')=yes; Q('h14','h9')=yes; Q('h14','h10')=yes;Q('h14','h12')=yes;Q('h14','h13')=yes;Q('h14','h14')=yes;
Q('h15','h9')=yes; Q('h15','h10')=yes;Q('h15','h11')=yes;Q('h15','h13')=yes;Q('h15','h14')=yes;Q('h15','h15')=yes;
Q('h16','h10')=yes;Q('h16','h11')=yes;Q('h16','h12')=yes;Q('h16','h14')=yes;Q('h16','h15')=yes;Q('h16','h16')=yes;
Q('h17','h11')=yes;Q('h17','h12')=yes;Q('h17','h13')=yes;Q('h17','h15')=yes;Q('h17','h16')=yes;Q('h17','h17')=yes;
Q('h18','h12')=yes;Q('h18','h13')=yes;Q('h18','h14')=yes;Q('h18','h16')=yes;Q('h18','h17')=yes;Q('h18','h18')=yes;
Q('h19','h13')=yes;Q('h19','h14')=yes;Q('h19','h15')=yes;Q('h19','h17')=yes;Q('h19','h18')=yes;Q('h19','h19')=yes;
Q('h20','h14')=yes;Q('h20','h15')=yes;Q('h20','h16')=yes;Q('h20','h18')=yes;Q('h20','h19')=yes;Q('h20','h20')=yes;
Q('h21','h15')=yes;Q('h21','h16')=yes;Q('h21','h17')=yes;Q('h21','h19')=yes;Q('h21','h20')=yes;Q('h21','h21')=yes;
Q('h22','h16')=yes;Q('h22','h17')=yes;Q('h22','h18')=yes;Q('h22','h20')=yes;Q('h22','h21')=yes;Q('h22','h22')=yes;
Q('h23','h17')=yes;Q('h23','h18')=yes;Q('h23','h19')=yes;Q('h23','h21')=yes;Q('h23','h22')=yes;Q('h23','h23')=yes;


* ==========================================================
* PART 1: Base MIP
* ==========================================================

Variables
    z "total cost (objective)";

Integer Variables
    x(h,j) "operators starting at hour for company"
    L(h,j) "shortage at hour for company";

Equations
    obj               "objective definition"
    cap_per_hour(h)   "sum of operators starting at hour across companies <= capHour"
    cap_total(h)      "total operators active in window across companies <= capTotal"
    shortage(h,j)     "demand - covered <= L"
    shortage_cap(h,j) "L <= maxShort"
    shortage_total(j) "sum_h L(h,j) <= totShort(j)"
    min_coverage(h)   "minimum coverage in each window across companies >= minCov";

obj..
    z =e=
        sum((h,j), cost(h)*x(h,j))
      + 60*sum(i$peak(i), L(i,'c1'))
      + 30*sum(i$off(i),  L(i,'c1'))
      + 45*sum(i,         L(i,'c2'));

cap_per_hour(h)..
    sum(j, x(h,j)) =l= capHour(h);

cap_total(h)..
    sum((k,j)$Q(h,k), x(k,j)) =l= capTotal(h);

shortage(h,j)..
    demand(h,j) - sum(k$Q(h,k), x(k,j)) =l= L(h,j);

shortage_cap(h,j)..
    L(h,j) =l= maxShort(h,j);

shortage_total(j)..
    sum(h, L(h,j)) =l= totShort(j);

min_coverage(h)..
    sum((k,j)$Q(h,k), x(k,j)) =g= minCov(h);

Model Telecom_MIP /all/;

Solve Telecom_MIP using MIP minimizing z;

display "PART 1 (MIP) objective", z.l;
