---
title: Activities
categories:
  - BPMN
  - Process
tags:
  - BPMN
date: 2020-12-09 18:00:38
---
Activity 是在业务流程中执行的工作. 可以是原子的,也可以是非原子(复合)的. 作为 Process 一部分的活动类型有: Task ,Sub-Process 和 Call Activity,它们允许在图中包含可复用的任务和流程. 然而,Process 不是一个特定的图形对象. 它是一组图形对象,下面将重点介绍 **Sub-Process** 和 **Task** 两种图形对象

Activities 表示 Process 中执行工作的点. 它们是BPMN流程的可执行元素.

`Activity`类是一个抽象元素,是`FlowElement`的子类. Activity具体子类声明了除通用 `Activity` 语义外的其他语义

![Activity类图](https://s3.ax1x.com/2020/12/09/rCLjne.png)
<!--more-->
Activity类是所有具体Activity类型的抽象超类

Activity 元素继承了FlowElement的属性和模型关联. 下表展示了Activity元素的附加属性和模型关联

| 属性名                                               | 描述/使用                                                                                                                                                                                                                                                                                                                                                                                                  |
| ---------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| isForCompensation: boolean = false                   | A flag that identifies whether this Activity is intended for the purposes of compensation. If false, then this Activity executes as a result of normal execution flow. If true, this Activity is only activated when a Compensation Event is detected and initiated under Compensation Event visibility scope (see page 281 for more information on scopes).                                               |
| loopCharacteristics: LoopCharac- teristics [0..1]    | An Activity MAY be performed once or MAY be repeated. If repeated, the Activity MUST have loopCharacteristics that define the repe- tition criteria (if the isExecutable attribute of the Process is set to true).                                                                                                                                                                                         |
| resources: ResourceRole [0..*]                       | Defines the resource that will perform or will be responsible for the Activity. The resource, e.g., a performer, can be specified in the form of a specific individual, a group, an organization role or position, or an orga- nization.                                                                                                                                                                   |
| default: SequenceFlow [0..1]                         | The Sequence Flow that will receive a token when none of the conditionExpressions on other outgoing Sequence Flows evalu- ate to true. The default Sequence Flow should not have a conditionExpression. Any such Expression SHALL be ignored.                                                                                                                                                              |
| ioSpecification: Input OutputSpecification [0..1]    | The InputOutputSpecification defines the inputs and outputs and the InputSets and OutputSets for the Activity. See page 211 for more information on the InputOutputSpecification.                                                                                                                                                                                                                          |
| properties: Property [0..*]                          | Modeler-defined properties MAY be added to an Activity. These properties are contained within the Activity.                                                                                                                                                                                                                                                                                                |
| boundaryEventRefs: BoundaryEvent [0..*]              | This references the Intermediate Events that are attached to the boundary of the Activity.                                                                                                                                                                                                                                                                                                                 |
| dataInputAssociations: DataIn- putAssociation [0..*] | An optional reference to the DataInputAssociations. A DataInputAssociation defines how the DataInput of the Activity’s InputOutputSpecification will be populated.                                                                                                                                                                                                                                         |
| dataOutputAssociations: DataOutputAssociation [0..*] | An optional reference to the DataOutputAssociations.                                                                                                                                                                                                                                                                                                                                                       |
| startQuantity: integer = 1                           | The default value is 1. The value MUST NOT be less than 1. This attribute defines the number of tokens that MUST arrive before the Activity can begin. Note that any value for the attribute that is greater than 1 is an advanced type of modeling and should be used with caution.                                                                                                                       |
| completionQuantity: integer = 1                      | The default value is 1. The value MUST NOT be less than 1. This attribute defines the number of tokens that MUST be generated from the Activity. This number of tokens will be sent done any outgoing Sequence Flow (assuming any Sequence Flow conditions are satis- fied). Note that any value for the attribute that is greater than 1 is an advanced type of modeling and should be used with caution. |

此外,Activity 实例的某些属性值在 Activity被执行时可以被表达式获取.

显示活动元素的实例属性

| 属性名               | 描述/使用      |
| -------------------- | -------------- |
| state: string = None | Activity状态机 |

### 顺序流连接

Activity 可能是一个 **Sequence Flow**的指向目标;

    它可以有多个来源 **Sequence Flows**. 来源可能是选择路径或并行路径.   如果一个 Activity 没有来源 Sequence Flow, 那么这个 Activity 必须在实例化流程时同时完成实例化,仅有两个例外 **Compensation Activities** 和 **Event Sub-Processes**.

    注意 - 如果 **Activity** 有多个来源 **Sequence Flows**, 这时它被认为是一个不受控制的流. 此时任意一条路径的token到达,都将导致 Activity 被实例化. 它不会等待其他路径的token到达. 如果从同一路径或不同路径的其他token到达,将创建一个单独的 **Activity** 实例. 如果这个流需要被控制,流应收敛于 **Activity** 前的 **Gateway** 之上.

**Activity** 可能是 **Sequence Flows** 的来源;

    它可以有多个出向 **Sequence Flows**. 如果一个 **Activity** 有多个出向 **Sequence Flows** ,它将为所有的 **Sequence Flow** 创建各自的并行路径.




