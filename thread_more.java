package test;

import org.apache.http.HttpEntity;
import org.apache.http.HttpStatus;
import org.apache.http.StatusLine;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;

import java.io.IOException;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class postRequest {

    public static void postRequestTest(String para1, String para2, String para3) throws Exception {
        long begaintime = System.currentTimeMillis();//开始系统时间
        CloseableHttpClient httpclient = HttpClients.createDefault();

        String url = "https://www.baidu.com";
        HttpPost httpPost = new HttpPost(url);// 创建httpPost
        httpPost.setHeader("Authorization", "Bearer  qwertyu12345678zxcvbnm");
        httpPost.setHeader("Content-Type", "application/json");
        httpPost.setHeader("time", "11234567890");
        httpPost.setHeader("X-Accept-Locale", "zh_CN");

        //添加 body 参数
        String orderToken = postRequest1(para1);  //从上一个接口的返回数据里面获取参数
        String body = String.format("{\"Name\":\"%s\",\"age\":\"%s\",\"address\":\"%s\"}", para2, para3, orderToken);

        httpPost.setEntity(new StringEntity(body));

        //设置 params 参数-------------设置了body就不能再设置params
        //String params = "";
        //String charSet = "UTF-8";
        //StringEntity entity = new StringEntity(params, charSet);
        //httpPost.setEntity(entity);

        CloseableHttpResponse response = null;
        try {
            response = httpclient.execute(httpPost);
            StatusLine status = response.getStatusLine();
            int state = status.getStatusCode();
            if (state == HttpStatus.SC_OK) {
                HttpEntity responseEntity = response.getEntity();
                String jsonString = EntityUtils.toString(responseEntity);
                System.out.println("TakegoOrder 接口请求成功");
                //return jsonString;
                System.out.println(jsonString);
                if (jsonString.contains("\"success\":true") && jsonString.contains("\"time\":\"2018")) {
                    System.out.println("成功查询！！！！");
                } else {
                    System.err.println("查询失败！！----" + body);
                }

            } else {
                System.err.println("请求返回:" + state + "(" + url + ")");
            }
        } finally {
            if (response != null) {
                try {
                    response.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            try {
                httpclient.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
            long endTime = System.currentTimeMillis(); //结束时间
            System.out.println("  接口请求耗时 ： " + (endTime - begaintime));
        }
        //return null;
    }

}



    class MyThread implements Runnable {

        private String para1;
        private String para2;
        private String para3;
        private CountDownLatch countDownLatch;  //多线程结束后，执行后面的代码（计算时间、数量）

        public MyThread(String para1, String para2, String para3, CountDownLatch countDownLatch) {
            this.para1 = para1;
            this.para2 = para2;
            this.para3 = para3;
            this.countDownLatch = countDownLatch;
        }

        public void run() {

            try{
                postRequest.postRequestTest(para1, para2, para3);
            }catch(Exception e){
                e.printStackTrace();
            }finally {
                countDownLatch.countDown();
            }
        }


    }



     class Test {


        public static void main(String[] args) throws InterruptedException {

            long begaintime = System.currentTimeMillis();//开始系统时间

            //线程池
            ExecutorService pool = Executors.newCachedThreadPool();
            //设置集合点为93
            final int count = 50;
            CountDownLatch countDownLatch = new CountDownLatch(count);//与countDownLatch.await();实现运行完所有线程之后才执行后面的操作
            //final CyclicBarrier barrier = new CyclicBarrier(count);  //与barrier.await() 实现并发;
            //创建100个线程
            for(int i = 0; i < count; i++){

                MyThread target = new MyThread("para1", "para2", "para3", countDownLatch);
                //barrier.await();
                pool.execute(target);
            }

            pool.shutdown();
            try {
                countDownLatch.await();  //这一步是为了将全部线程任务执行完以后，开始执行后面的任务（计算时间，数量）
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            long endTime = System.currentTimeMillis(); //结束时间
            System.out.println(count + " 个  接口请求总耗时 ： "+(endTime-begaintime)+"-----平均耗时为"+ ((endTime-begaintime)/count));
        }

    }


