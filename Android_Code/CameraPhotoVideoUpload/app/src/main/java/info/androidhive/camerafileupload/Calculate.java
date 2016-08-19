package info.androidhive.camerafileupload;

/**
 * Created by Diks on 4/24/2016.
 */
import android.util.Log;

import java.util.Stack;

public class Calculate {

    public int evaluate(String expression){

        int ans = 0;

        Log.e("string",expression);
        Log.e("calculation starts of ", "evalll");
        char[] tokens = expression.toCharArray();

        // Stack for numbers: 'values'
        Stack<Integer> values = new Stack<Integer>();

        // Stack for Operators: 'ops'
        Stack<Character> ops = new Stack<Character>();
        int i=0;
        int flag=0;
        while (i<tokens.length)
        {
            Log.e("tokens",tokens[i]+"");
            // Current token is a whitespace, skip i

            // Current token is a number, push it to stack for numbers
            if (tokens[i] >= '0' && tokens[i] <= '9')
            {

                Log.e("enter",""+tokens[i]);
                StringBuffer sbuf = new StringBuffer();
                // There may be more than one digits in number
                while (i < tokens.length && tokens[i] >= '0' && tokens[i] <= '9'){
                    sbuf.append(tokens[i]);
                    Log.e("token",""+tokens[i]);
                    flag=1;
                    i++;}
                if(flag==0)
                {
                    i++;
                }
                Log.e("stringbuilder",sbuf+"");
                values.push(Integer.parseInt(sbuf.toString()));
                Log.e("value",values+"");
            }

            // Current token is an opening brace, push it to 'ops'
            else if (tokens[i] == '('){
                ops.push(tokens[i]);
                i++;}

            // Closing brace encountered, solve entire brace
            else if (tokens[i] == ')')
            {
                while (ops.peek() != '(')
                    values.push(applyOp(ops.pop(), values.pop(), values.pop()));
                ops.pop();
                i++;
            }

            // Current token is an operator.
            else if (tokens[i] == '+' || tokens[i] == '-' ||
                    tokens[i] == '*' || tokens[i] == '/')
            {
                // While top of 'ops' has same or greater precedence to current
                // token, which is an operator. Apply operator on top of 'ops'
                // to top two elements in values stack
                while (!ops.empty() && hasPrecedence(tokens[i], ops.peek()))
                    values.push(applyOp(ops.pop(), values.pop(), values.pop()));
                Log.e("vlues token",values+"");
                // Push current token to 'ops'.
                ops.push(tokens[i]);
                Log.e("opssss",ops+"");
                i++;
            }
        }
        Log.e("ops",ops+"");
        // Entire expression has been parsed at this point, apply remaining
        // ops to remaining values
        while (!ops.empty()){
            int x=applyOp(ops.pop(), values.pop(), values.pop());
            Log.e("x",x+"");
            values.push(x);}
        Log.e("end value",values+"");
        // Top of 'values' contains result, return it
        return values.pop();
    }

    // Returns true if 'op2' has higher or same precedence as 'op1',
    // otherwise returns false.
    public static boolean hasPrecedence(char op1, char op2)
    {
        if (op2 == '(' || op2 == ')')
            return false;
        if ((op1 == '*' || op1 == '/') && (op2 == '+' || op2 == '-'))
            return false;
        else
            return true;
    }

    // A utility method to apply an operator 'op' on operands 'a'
    // and 'b'. Return the result.
    public static int applyOp(char op, int b, int a)
    {
        switch (op)
        {
            case '+':
                return a + b;
            case '-':
                return a - b;
            case '*':
                return a * b;
            case '/':
                if (b == 0)
                    throw new
                            UnsupportedOperationException("Cannot divide by zero");
                return a / b;
        }
        return 0;
    }
}
