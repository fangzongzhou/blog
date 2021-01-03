---
title: Basic Process Concepts(基本流程概念)
categories:
  - BPMN
  - Process
tags:
  - BPMN
date: 2020-12-09 16:44:15
---

## BPMN流程类型

业务流程建模用于向各种各样的受众传达各种各样的信息. BPMN旨在涵盖多种类型的模型,并允许创建端到端的业务流程. 下面是三种基本的BPMN流程类型:

- Private Non-executable (internal) Business Processes
- Private Executable (internal) Business Processes
- Public Processes

### Private (Internal) Business Processes

*Private* **Business Process** 是特定的组织内部的流程. 这些流程通常被叫做工作流或BPM流程. 在web服务中通常叫做服务编排. 两种典型的私有流程: *executable* 和 *non-executable*.可执行流程是指根据指定语义定义执行了建模的流程. 当然,在流程开发周期中,会有某些阶段,流程没有足够的细节可以执行. 不可执行流程是已建模的专用流程，目的是在建模者定义的详细级别上记录流程行为.因此,执行所需的信息（例如形式条件表达式）通常不包括在不可执行的流程中

<!--more-->

如果使用类似泳道的表示法（例如，协作，请参见下文），则私有业务流程将包含在单个池中。因此，流程流包含在池中，并且不能越过池的边界。消息流可以越过Pool边界，以显示单独的私有业务流程之间存在的交互。

![私有流程示例](https://s3.ax1x.com/2020/12/09/rCWYW9.png)

### Public Processes

公共流程表示私有业务流程与另一个流程或参与者之间的交互（请参见图10.5）。公共流程中仅包括用于与其他参与者进行交流的那些活动，以及这些活动的顺序。私有业务流程的所有其他“内部”活动都不会在公共流程中显示。因此，公共流程向外界显示了与该业务流程进行交互所必需的消息以及这些消息的顺序。公共流程可以单独建模，也可以在协作中建模，以显示公共流程活动与其他参与者之间的消息流。请注意，流程的公共类型在BPMN 1.2中被命名为“抽象”。

![公有流程示例](https://s3.ax1x.com/2020/12/09/rCfilR.png)

## BPMN通用元素使用

对于 **Process** , **Choreography**(编排)以及协作,一些元素是常见的. 它们被用在图表中.

**Choreography** 常使用 **Messages**, **Message Flows**, *Participants*, **Sequence Flows**, *Artifacts*, *Correlations*, *Expressions*, 和 *Services* 等元素

关键图形元素 **Gateways** 和 **Events** 对于 Process 和 Choreography 都是通用且常用的.


