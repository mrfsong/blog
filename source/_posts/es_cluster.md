---
title: elasticsearch集群原理
date: 2018-04-01 12:47:30
categories: 大数据
tags: ElasticSearch
---

{% blockquote %}
ElasticSearch搜索引擎原理总结
{% endblockquote %}
<!-- more -->



## ElasticSearch的几种节点类型

1. Master Eligible Node （候选主节点）：设置成node.master=true (default)都可能会被选举为主节点；
2. Master Node （主节点）：由候选主节点选举出来的，负责管理 ES 集群，通过广播的机制与其他节点维持关系，负责集群中的 DDL 操作（创建/删除索引），管理其他节点上的分片（shard）；
3. Data Node（数据节点）：很好理解，存放数据的节点，负责数据的增删改查 CRUD；
4. Ingest Node（提取节点）：能执行预处理管道，有自己独立的任务要执行，类似于 logstash 的功能，不负责数据也不负责集群相关的事务；
5. Tribe Node（部落节点）：协调集群与集群之间的节点；
6. Coordinating Node(协调节点)：每一个节点都是一个潜在的协调节点，且不能被禁用，协调节点最大的作用就是将各个分片里的数据汇集起来一并返回给客户端，因此 ES 的节点需要有足够的 CPU 和内存去处理协调节点的 gather 阶段

## ElasticSearch集群启动过程

## ElasticSearch Gateway模块

gateway模块用于存储es集群的元数据信息。这部分信息主要包括所有的索引连同索引设置和显式的mapping信息。集群元数据的每一次改变（比如增加删除索引等），这些信息都要通过gateway模块进行持久化。当集群第一次启动的时候，这些信息就会从gateway模块中读出并应用。
设置在node级别上的gateway会自动控制索引所用的gateway。比如设置了local gataway，则每一个在这个node上创建的index都会应用他们在索引级别的local gateway。如果索引不需要持久化状态，需要显式的设置为none（这也是唯一可以设置的值）。默认的gateway设置是local gateway。

## ElasticSearch文档（Type）更新过程

协调节点负责创建索引,转发请求到主分片节点,等待响应,回复客户端

路径:action.index.TransportIndexAction#doExecute
检查索引是否存在,如果不存在,且允许自动创建索引,就创建他

创建索引请求被发送到 master, 直到收到其 Response 之后,进入写doc操作主逻辑.master 什么时候返回Response? 在 master 执行完创建索引流程,将新的 clusterState 发布完毕后才会返回.那什么才算发布完毕呢?默认情况下,master 发布 clusterState 的 Request 收到半数以上的节点 Response, 认为发布成功.负责写数据的节点会先走一遍内容路由的过程已处理没有收到最新 clusterState 的情况.




_________________
*To be continued*
_________________


<!-- {% codeblock lang:objc %}
{% endcodeblock %} -->

