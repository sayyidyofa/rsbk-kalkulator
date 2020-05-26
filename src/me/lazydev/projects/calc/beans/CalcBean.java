package me.lazydev.projects.calc.beans;

import java.math.BigDecimal;
import com.udojava.evalex.Expression;
import javax.ejb.Stateful;

@Stateful(name = "CalcEJB")
public class CalcBean {
    // https://stackoverflow.com/questions/7258538/method-for-evaluating-math-expressions-in-java/13975620
    public String calculate(String input) {
        BigDecimal result;
        try {
            result = new Expression(input).eval();
            return result.toPlainString();
        } catch (Expression.ExpressionException expressionException) {
            return expressionException.getLocalizedMessage();
        } catch (NullPointerException nullPointerException) {
            return "Calculation returned null";
        } catch (java.lang.ArithmeticException arithmeticException) {
            return "Please don't try weird operations with zero >:(";
        }
    }

    // https://github.com/uklimaschewski/EvalEx/blob/master/src/main/java/com/udojava/evalex/Expression.java#L1218
    public boolean isNumber(String st) {
        if (st.charAt(0) == '-' && st.length() == 1) {
            return false;
        } else if (st.charAt(0) == '+' && st.length() == 1) {
            return false;
        } else if (st.charAt(0) == '.' && (st.length() == 1 || !Character.isDigit(st.charAt(1)))) {
            return false;
        } else if (st.charAt(0) != 'e' && st.charAt(0) != 'E') {
            char[] var2 = st.toCharArray();

            for (char ch : var2) {
                if (!Character.isDigit(ch) && ch != '-' && ch != '.' && ch != 'e' && ch != 'E' && ch != '+') {
                    return false;
                }
            }

            return true;
        } else {
            return false;
        }
    }
}
