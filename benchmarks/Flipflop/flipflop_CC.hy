--****************************************************--
--****************************************************--
--   Laboratoire Specification et Verification
--
--   Modeling of the circuit described in "Verification of timed circuits with symbolic delays" (Clariso -- Cortadella)
--   Precise Model of CC07, including the synthesis of tCKQ
--
--   Etienne ANDRE and Laurent FRIBOURG
--
--   Created      : 2007/11
--   Last modified: 2010/03/26
--****************************************************--
--****************************************************--

var 	s, ckG1, ckG2, ckG3, ckG4, x_checker --, x_extra
		: clock;

	tHI, tLO,
	tSetup, tHold,
	tCKQ,
	dG1_l, dG1_u,
	dG2_l, dG2_u,
	dG3_l, dG3_u,
	dG4_l, dG4_u
			: parameter;

-- 	qLevel,
	extra_level
			: discrete;


--****************************************************--
  automaton input
--****************************************************--
synclabs: dUp, dDown, ckUp, ckDown; -- , qUp
initially Input0;

loc Input0: while s <= tLO - tSetup wait {}
	when s = tLO - tSetup sync dUp do {} goto Input1;

loc Input1: while s <= tLO wait {}
	when s = tLO sync ckUp do {} goto Input2;

loc Input2: while s <= tLO + tHold wait {}
	when s = tLO + tHold sync dDown do {} goto Input3;
	when extra_level = 1 & s = tLO + tCKQ do {extra_level' = 0} goto Input2;

loc Input3: while s <= tLO + tHI wait {}
	when s = tLO + tHI sync ckDown do {} goto Input4;
	when extra_level = 1 & s = tLO + tCKQ do {extra_level' = 0} goto Input3;

loc Input4: while True wait {}
	when extra_level = 1 & s = tLO + tCKQ do {extra_level' = 0} goto Input4;

end -- input


--****************************************************--
  automaton checker
--****************************************************--
synclabs: qUp, go_to_good, go_to_bad;
initially maybe;

loc maybe: while True wait {}
	when True sync qUp do {x_checker' = 0} goto check;

loc check: while x_checker <= 0 wait {}
	when x_checker = 0 & extra_level = 0 sync go_to_good goto good;
	when x_checker = 0 & extra_level = 1 sync go_to_bad goto bad;

loc good: while True wait {}

loc bad: while True wait {}

end


--****************************************************--
  automaton g1
--****************************************************--
-- Input : D, ck, qG2
-- Output : qG1

synclabs: dUp, dDown, ckUp, ckDown, qG2Up, qG2Down,
	qG1Up, qG1Down;
initially G10011;

loc G10000: while ckG1 <= dG1_u wait {}
	when True sync dUp do {ckG1' = 0} goto G11000;
	when True sync ckUp do {ckG1' = 0} goto G10100;
	when True sync qG2Up do {ckG1' = 0} goto G10010;
	when ckG1 >= dG1_l sync qG1Up do {} goto G10001;

loc G10001: while ckG1 >= 0 wait {}
	when True sync dUp do {} goto G11001;
	when True sync ckUp do {} goto G10101;
	when True sync qG2Up do {} goto G10011;

loc G10010: while ckG1 <= dG1_u wait {}
	when True sync dUp do {} goto G11010;
	when True sync ckUp do {} goto G10110;
	when True sync qG2Down do {ckG1' = 0} goto G10000;
	when ckG1 >= dG1_l sync qG1Up do {} goto G10011;

loc G10011: while ckG1 >= 0 wait {}
	when True sync dUp do {ckG1' = 0} goto G11011;
	when True sync ckUp do {ckG1' = 0} goto G10111;
	when True sync qG2Down do {} goto G10001;

loc G10100: while ckG1 <= dG1_u wait {}
	when True sync dUp do {ckG1' = 0} goto G11100;
	when True sync ckDown do {ckG1' = 0} goto G10000;
	when True sync qG2Up do {} goto G10110;
	when ckG1 >= dG1_l sync qG1Up do {} goto G10101;

loc G10101: while ckG1 >= 0 wait {}
	when True sync dUp do {} goto G11101;
	when True sync ckDown do {} goto G10001;
	when True sync qG2Up do {ckG1' = 0} goto G10111;

loc G10110: while ckG1 >= 0 wait {}
	when True sync dUp do {} goto G11110;
	when True sync ckDown do {ckG1' = 0} goto G10010;
	when True sync qG2Down do {ckG1' = 0} goto G10100;

loc G10111: while ckG1 <= dG1_u wait {}
	when True sync dUp do {ckG1' = 0} goto G11111;
	when True sync ckDown do {} goto G10011;
	when True sync qG2Down do {} goto G10101;
	when ckG1 >= dG1_l sync qG1Down do {} goto G10110;

loc G11000: while ckG1 <= dG1_u wait {}
	when True sync dDown do {ckG1' = 0} goto G10000;
	when True sync ckUp do {ckG1' = 0} goto G11100;
	when True sync qG2Up do {} goto G11010;
	when ckG1 >= dG1_l sync qG1Up do {} goto G11001;

loc G11001: while ckG1 >= 0 wait {}
	when True sync dDown do {} goto G10001;
	when True sync ckUp do {} goto G11101;
	when True sync qG2Up do {ckG1' = 0} goto G11011;

loc G11010: while ckG1 >= 0 wait {}
	when True sync dDown do {ckG1' = 0} goto G10010;
	when True sync ckUp do {} goto G11110;
	when True sync qG2Down do {ckG1' = 0} goto G11000;

loc G11011: while ckG1 <= dG1_u wait {}
	when True sync dDown do {} goto G10011;
	when True sync ckUp do {ckG1' = 0} goto G11111;
	when True sync qG2Down do {} goto G11001;
	when ckG1 >= dG1_l sync qG1Down do {} goto G11010;

loc G11100: while ckG1 <= dG1_u wait {}
	when True sync dDown do {ckG1' = 0} goto G10100;
	when True sync ckDown do {ckG1' = 0} goto G11000;
	when True sync qG2Up do {} goto G11110;
	when ckG1 >= dG1_l sync qG1Up do {} goto G11101;

loc G11101: while ckG1 >= 0 wait {}
	when True sync dDown do {} goto G10101;
	when True sync ckDown do {} goto G11001;
	when True sync qG2Up do {ckG1' = 0} goto G11111;

loc G11110: while ckG1 >= 0 wait {}
	when True sync dDown do {} goto G10110;
	when True sync ckDown do {} goto G11010;
	when True sync qG2Down do {ckG1' = 0} goto G11100;

loc G11111: while ckG1 <= dG1_u wait {}
	when True sync dDown do {ckG1' = 0} goto G10111;
	when True sync ckDown do {ckG1' = 0} goto G11011;
	when True sync qG2Down do {} goto G11101;
	when ckG1 >= dG1_l sync qG1Down do {} goto G11110;
end -- g1



--****************************************************--
  automaton g2
--****************************************************--
-- Input : qG1, ck
-- Output : qG2

synclabs: qG1Up, qG1Down, ckUp, ckDown,
	qG2Up, qG2Down;
initially G2101;

loc G2001: while ckG2 >= 0 wait {}
	when True sync qG1Up do {} goto G2101;
	when True sync ckUp do {} goto G2011;

loc G2000: while ckG2 <= dG2_u wait {}
	when True sync qG1Up do {ckG2' = 0} goto G2100;
	when True sync ckUp do {ckG2' = 0} goto G2010;
	when ckG2 >= dG2_l sync qG2Up do {} goto G2001;

loc G2011: while ckG2 >= 0 wait {}
	when True sync qG1Up do {ckG2' = 0} goto G2111;
	when True sync ckDown do {} goto G2001;

loc G2010: while ckG2 <= dG2_u wait {}
	when True sync qG1Up do {} goto G2110;
	when True sync ckDown do {ckG2' = 0} goto G2000;
	when ckG2 >= dG2_l sync qG2Up do {} goto G2011;

loc G2101: while ckG2 >= 0 wait {}
	when True sync qG1Down do {} goto G2001;
	when True sync ckUp do {ckG2' = 0} goto G2111;

loc G2100: while ckG2 <= dG2_u wait {}
	when True sync qG1Down do {ckG2' = 0} goto G2000;
	when True sync ckUp do {} goto G2110;
	when ckG2 >= dG2_l sync qG2Up do {} goto G2101;

loc G2111: while ckG2 <= dG2_u wait {}
	when True sync qG1Down do {} goto G2011;
	when True sync ckDown do {} goto G2101;
	when ckG2 >= dG2_l sync qG2Down do {} goto G2110;

loc G2110: while ckG2 >= 0 wait {}
	when True sync qG1Down do {ckG2' = 0} goto G2010;
	when True sync ckDown do {ckG2' = 0} goto G2100;
end -- g2



--****************************************************--
  automaton g3
--****************************************************--
-- Input : q, ck, qG2
-- Output : qG3

synclabs: qUp, qDown, ckUp, ckDown, qG2Up, qG2Down,
	qG3Up, qG3Down;
initially G30011;

loc G30000: while ckG3 <= dG3_u wait {}
	when True sync qUp do {ckG3' = 0} goto G31000;
	when True sync ckUp do {ckG3' = 0} goto G30100;
	when True sync qG2Up do {ckG3' = 0} goto G30010;
	when ckG3 >= dG3_l sync qG3Up do {} goto G30001;

loc G30001: while ckG3 >= 0 wait {}
	when True sync qUp do {} goto G31001;
	when True sync ckUp do {} goto G30101;
	when True sync qG2Up do {} goto G30011;

loc G30010: while ckG3 <= dG3_u wait {}
	when True sync qUp do {} goto G31010;
	when True sync ckUp do {} goto G30110;
	when True sync qG2Down do {ckG3' = 0} goto G30000;
	when ckG3 >= dG3_l sync qG3Up do {} goto G30011;

loc G30011: while ckG3 >= 0 wait {}
	when True sync qUp do {ckG3' = 0} goto G31011;
	when True sync ckUp do {ckG3' = 0} goto G30111;
	when True sync qG2Down do {} goto G30001;

loc G30100: while ckG3 <= dG3_u wait {}
	when True sync qUp do {ckG3' = 0} goto G31100;
	when True sync ckDown do {ckG3' = 0} goto G30000;
	when True sync qG2Up do {} goto G30110;
	when ckG3 >= dG3_l sync qG3Up do {} goto G30101;

loc G30101: while ckG3 >= 0 wait {}
	when True sync qUp do {} goto G31101;
	when True sync ckDown do {} goto G30001;
	when True sync qG2Up do {ckG3' = 0} goto G30111;

loc G30110: while ckG3 >= 0 wait {}
	when True sync qUp do {} goto G31110;
	when True sync ckDown do {ckG3' = 0} goto G30010;
	when True sync qG2Down do {ckG3' = 0} goto G30100;

loc G30111: while ckG3 <= dG3_u wait {}
	when True sync qUp do {ckG3' = 0} goto G31111;
	when True sync ckDown do {} goto G30011;
	when True sync qG2Down do {} goto G30101;
	when ckG3 >= dG3_l sync qG3Down do {} goto G30110;

loc G31000: while ckG3 <= dG3_u wait {}
	when True sync qDown do {ckG3' = 0} goto G30000;
	when True sync ckUp do {ckG3' = 0} goto G31100;
	when True sync qG2Up do {} goto G31010;
	when ckG3 >= dG3_l sync qG3Up do {} goto G31001;

loc G31001: while ckG3 >= 0 wait {}
	when True sync qDown do {} goto G30001;
	when True sync ckUp do {} goto G31101;
	when True sync qG2Up do {ckG3' = 0} goto G31011;

loc G31010: while ckG3 >= 0 wait {}
	when True sync qDown do {ckG3' = 0} goto G30010;
	when True sync ckUp do {} goto G31110;
	when True sync qG2Down do {ckG3' = 0} goto G31000;

loc G31011: while ckG3 <= dG3_u wait {}
	when True sync qDown do {} goto G30011;
	when True sync ckUp do {ckG3' = 0} goto G31111;
	when True sync qG2Down do {} goto G31001;
	when ckG3 >= dG3_l sync qG3Down do {} goto G31010;

loc G31100: while ckG3 <= dG3_u wait {}
	when True sync qDown do {ckG3' = 0} goto G30100;
	when True sync ckDown do {ckG3' = 0} goto G31000;
	when True sync qG2Up do {} goto G31110;
	when ckG3 >= dG3_l sync qG3Up do {} goto G31101;

loc G31101: while ckG3 >= 0 wait {}
	when True sync qDown do {} goto G30101;
	when True sync ckDown do {} goto G31001;
	when True sync qG2Up do {ckG3' = 0} goto G31111;

loc G31110: while ckG3 >= 0 wait {}
	when True sync qDown do {} goto G30110;
	when True sync ckDown do {} goto G31010;
	when True sync qG2Down do {ckG3' = 0} goto G31100;

loc G31111: while ckG3 <= dG3_u wait {}
	when True sync qDown do {ckG3' = 0} goto G30111;
	when True sync ckDown do {ckG3' = 0} goto G31011;
	when True sync qG2Down do {} goto G31101;
	when ckG3 >= dG3_l sync qG3Down do {} goto G31110;
end -- g3



--****************************************************--
  automaton g4
--****************************************************--
-- Input : qG3
-- Output : q

synclabs: qG3Up, qG3Down,
	qUp, qDown;
initially G410;

loc G401: while ckG4 >= 0 wait {}
	when True sync qG3Up do {ckG4' = 0} goto G411;

loc G411: while ckG4 <= dG4_u wait {}
	when True sync qG3Down do {} goto G401;
	when ckG4 >= dG4_l sync qDown do {} goto G410; -- qLevel'=0

loc G410: while ckG4 >= 0 wait {}
	when True sync qG3Down do {ckG4' = 0} goto G400;

loc G400: while ckG4 <= dG4_u wait {}
	when True sync qG3Up do {} goto G410;
	when ckG4 >= dG4_l sync qUp do {} goto G401;  -- qLevel' = 1 -- q goes high at this point (*tCKQ' = s - tLO, *)
end -- g4



--****************************************************--
--****************************************************--
-- ANALYSIS
--****************************************************--
--****************************************************--

var init, final_reg : region;

init := True
	----------------------
	-- Initial state
	----------------------
	& loc[input] = Input0
	& loc[g1] = G10011
	& loc[g2] = G2101
	& loc[g3] = G30011
	& loc[g4] = G410
	& s = 0
-- 	& qLevel = 0
-- 	& ckLevel = 1 -- actually initially CK = 0, then raise to 1, then go back to 0: we are here only interested in the last fall of CK

	----------------------
	-- Clocks
	----------------------
	& ckG1 >= 0
	& ckG2 >= 0
	& ckG3 >= 0
	& ckG4 >= 0

	----------------------
	-- Constraints
	----------------------

	& dG1_l >= 0
	& dG2_l >= 0
	& dG3_l >= 0
	& dG4_l >= 0

	& dG1_l <= dG1_u 
	& dG2_l <= dG2_u
	& dG3_l <= dG3_u
	& dG4_l <= dG4_u
	
-- 	& loc[extra_signal] = Checker_init
	& extra_level = 1 -- actually 0, but here only interested in the fall 1 -> 0
-- 	& x_extra = 0
	
	& loc[checker] = maybe
	& x_checker = 0

	----------------------
	-- Result of IMITATOR 2
	----------------------
--       & dG2_l <= dG2_u
--       & 0 < dG1_l
--       & tSetup <= tLO
-- --       & tSetup < tLO -- IMITATOR 1
--       & 0 <= dG3_u
--       & dG3_l <= dG3_u
--       & dG1_l <= dG1_u
--       & dG1_u < tSetup
--       & tHold <= dG4_u + dG3_u
--       & dG4_u + dG3_u < tHI
--       & dG3_u < tHold
--       & dG4_l + dG3_l <= tHold
--       & dG4_l <= dG4_u
--       & dG4_l <= tHold

	
-- 	& False

	----------------------
	-- Pi0
	----------------------
	& tHI=24
	& tLO=15
-- 	& tSetup=10
-- 	& tHold=17
	& dG1_l=7
-- 	& dG1_u=7
	& dG2_l=5
-- 	& dG2_u=6
	& dG3_l=8
-- -- 	& dG3_u=10
	& dG4_l=3
-- -- 	& dG4_u=7

-- 	& tCKQ = 15
;

final_reg := reach forward from init endreach;

prints "========== POST* ==========";

-- print final_reg;

prints "========== REACHABLE BAD STATES ==========";

-- bad state : CK = 0 (input4) & Q did not raise (qLevel = 0)
print (hide non_parameters in final_reg & (loc[checker] = bad) endhide);

prints "========== REACHABLE GOOD STATES ==========";

-- bad state : CK = 0 (input4) & Q did not raise (qLevel = 0)
print (hide non_parameters in final_reg & (loc[checker] = good) endhide);

