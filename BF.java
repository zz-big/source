package test;

import java.sql.*;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.CyclicBarrier;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class BF {
    public static void main(String[] args) {
        int count = 2;// 次数并发

        CyclicBarrier cyclicBarrier = new CyclicBarrier(count);
        ExecutorService executorService = Executors.newFixedThreadPool(count);

        long now = System.nanoTime();

        for (int i = 0; i < count; i++)
            executorService.execute(new BF().new Task(cyclicBarrier));
        executorService.shutdown();
        while (!executorService.isTerminated()) {
            try {
                Thread.sleep(10);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }

        long end = System.nanoTime();
        System.out.println(" 总时间差为（单位：毫秒）!——————————" + (double) (end - now) / 1000000 + "ms");

    }

    public class Task implements Runnable {
        private CyclicBarrier cyclicBarrier;

        public Task() {

        }

        public Task(CyclicBarrier cyclicBarrier) {
            this.cyclicBarrier = cyclicBarrier;
        }

        @Override
        public void run() {

            try {
                // 等待所有任务准备就绪

                // 连接数据库
                Class.forName("com.mysql.jdbc.Driver").newInstance();
                String url = "jdbc:mysql://localhost:3306/db";
                String user = "root";
                String password = "root1";


                Connection conn = null;
                try {
                    conn = DriverManager.getConnection(url, user, password);
                     System.out.println(Thread.currentThread()+ "数据库连接成功");
                } catch (SQLException e) {
                    e.printStackTrace();
                }

                cyclicBarrier.await();
                // 测试内容

                String str1 = "INSERT INTO sys_user(user_code,user_name,user_password,user_state) VALUES('m0001','小书','456','1')";

                PreparedStatement localPreparedStatement = conn.prepareStatement(str1);

                long now = System.nanoTime();

                // ResultSet localResultSet = localPreparedStatement.executeQuery();
                // boolean localResultSet = localPreparedStatement.execute();
                // int localResultSet = localPreparedStatement.executeUpdate();

                for (int i = 0; i < 3; i++) {
                    int localResultSet = localPreparedStatement.executeUpdate();

                    System.out.println(localResultSet);
                }

                long end = System.nanoTime();

                System.out.println("SQL语句的开始时间" + now + "ns" + "\n" + "结束时间" + end + "ns");
                System.out.println(" 时间差为（单位：秒）!——————————" + (double) (end - now) / 1000000000 + "s");

            } catch (Exception e) {
                e.printStackTrace();
            }
        }

    }
}
