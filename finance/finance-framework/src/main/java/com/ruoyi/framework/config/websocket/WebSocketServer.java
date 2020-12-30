package com.ruoyi.framework.config.websocket;

import com.alibaba.fastjson.JSON;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.websocket.*;
import javax.websocket.server.PathParam;
import javax.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.concurrent.CopyOnWriteArraySet;

/**
 * WebSocket服务
 * 
 * @author admin 
 * @date 2019年11月6日
 */
//@ServerEndpoint("/websocket/{cid}")
//@Component
public class WebSocketServer {

    private static final transient Logger log = LoggerFactory.getLogger(WebSocketServer.class);

    // 静态变量，用来记录当前在线连接数。应该把它设计成线程安全的。
    private static int onlineCount = 0;
    // concurrent包的线程安全Set，用来存放每个客户端对应的MyWebSocket对象。
    private static CopyOnWriteArraySet<WebSocketServer> webSocketSet = new CopyOnWriteArraySet<WebSocketServer>();
    // 与某个客户端的连接会话，需要通过它来给客户端发送数据
    private Session session;
    // 接收cid(客户端ID)
    private String cid = "";

    /**
     * 连接建立成功调用的方法
     */
    @OnOpen
    public void onOpen(Session session, @PathParam("cid") String cid) {
        this.session = session;
        webSocketSet.add(this); // 加入set中
        addOnlineCount(); // 在线数加1
        log.info("有新客户端开始监听:" + cid + ",当前在线客户端数为" + getOnlineCount());
        this.cid = cid;
        try {
            sendMessage("连接成功");
        } catch (IOException e) {
            log.error("websocket IO异常");
        }
    }

    /**
     * 连接关闭调用的方法
     */
    @OnClose
    public void onClose() {
        webSocketSet.remove(this); // 从set中删除
        subOnlineCount(); // 在线数减1
        log.info("有一连接关闭！当前在线客户端数为" + getOnlineCount());
    }

    /**
     * 收到客户端消息后调用的方法
     * @param message 客户端发送过来的消息
     * @param session
     */
    @OnMessage
    public void onMessage(String message, Session session) {
        log.info("收到来自客户端" + cid + "的信息:" + message);
        // 群发消息
        for (WebSocketServer item : webSocketSet) {
            try {
                item.sendMessage(message);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * 错误
     * 
     * @param session
     * @param error
     */
    @OnError
    public void onError(Session session, Throwable error) {
        log.error("发生错误");
        error.printStackTrace();
    }

    /**
     * 实现服务器主动推送
     */
    public void sendMessage(String message) throws IOException {
        this.session.getBasicRemote().sendText(message);
    }

    /**
     * 实现服务器主动推送
     */
    public void sendObject(Object obj) throws IOException {
        try {
            this.session.getBasicRemote().sendObject(obj);
        } catch (EncodeException e) {
            log.error("推送对象发生错误", e);
        }
    }

    /**
     * 群发自定义消息
     * 
     * @param message
     * @param cid
     * @throws IOException
     */
    public static void sendInfo(String message, @PathParam("cid") String cid) throws IOException {
        log.info("推送消息到客户端" + cid + "，推送内容:" + message);
        for (WebSocketServer item : webSocketSet) {
            try {
                // 这里可以设定只推送给这个cid的，为null则全部推送
                if (cid == null) {
                    item.sendMessage(message);
                } else if (item.cid.equals(cid)) {
                    item.sendMessage(message);
                }
            } catch (IOException e) {
                continue;
            }
        }
    }

    /**
     * 群发自定义对象
     * 
     * @param message
     * @param cid
     * @throws IOException
     */
    public static void sendObject(Object obj, @PathParam("cid") String cid) throws IOException {
        log.info("推送消息到客户端" + cid + "，推送内容:" + JSON.toJSONString(obj));
        for (WebSocketServer item : webSocketSet) {
            try {
                // 这里可以设定只推送给这个cid的，为null则全部推送
                if (cid == null) {
                    item.sendObject(obj);
                } else if (item.cid.equals(cid)) {
                    item.sendObject(obj);
                }
            } catch (IOException e) {
                continue;
            }
        }
    }

    /**
     * 获取在线数量
     * 
     * @return
     */
    public static synchronized int getOnlineCount() {
        return onlineCount;
    }

    /**
     * 在线数量自增
     */
    public static synchronized void addOnlineCount() {
        WebSocketServer.onlineCount++;
    }

    /**
     * 在线数量自减
     */
    public static synchronized void subOnlineCount() {
        WebSocketServer.onlineCount--;
    }
}