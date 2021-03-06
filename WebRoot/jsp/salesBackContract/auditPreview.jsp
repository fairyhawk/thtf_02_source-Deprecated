<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" pageEncoding="UTF-8"
	contentType="text/html; charset=utf-8"%>
<%@ include file="/jsp/common/taglibs.jsp"%>
<%@taglib prefix="tf" uri="localhost" %>
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title>评审表查看</title>
		<link href="${ctx}/css/css.css" rel="stylesheet" type="text/css" />
		<link href="${ctx}/css/input.css" rel="stylesheet" type="text/css" />
		<script type="text/javascript" src="${ctx}/js/tad_bs2.js"></script>
		<script type="text/javascript" src="${ctx}/js/common/common.js"></script>
		<script type="text/javascript" src="${ctx}/js/jquery-1.4.2.min.js"></script>
		<script type="text/javascript" src="${ctx}/js/jquery.validate.min.js"></script>
		<script type="text/javascript" src="${ctx}/js/messages_cn.js"></script>		
	<style type="text/css">
	<!--
		body{font-family:"宋体"; font-size:13px; font-weight:bold;}
		.tad_1{border-left:1px solid #000000; border-bottom:1px solid #000000; }
		.tad_1 td{border-right:1px solid #000000;border-top:1px solid #000000;color:#000000;white-space:nowrap; padding:3px 0px 3px 0px;}
		.tad td{padding-bottom:5px;}
		.tad_2{ border-bottom:1px solid #000000; }
	.STYLE1 {
		font-size: 24px;
		font-weight: bold;
	}
	@media   print   {   
  		.buttonNoPrint {display:none;}   
  		}
	.STYLE2 {font-size: 14px}
	-->
	</style>
	
	<script type="text/javascript">
	$(document).ready(function(){
			$("#printOfshow").click(function(){
			$("#DivTr").hide();
			wb.execwb(6,6);
			$("#DivTr").show();
		});
		 });	


		function printPreview(){    
			 $("#DivTr").hide();   
			// 打印页面预览    
			wb.execwb(7,1);
			$("#DivTr").show();       
		}    
		function printSetup(){    
			// 打印页面设置    
			wb.execwb(8,1);    
		}

		function  printIt(img){ 
			
  			//打印后按钮变灰 不可用
			img.style.filter=" Alpha(opacity=50);-moz-opacity:.1;opacity:0.1";
			
  			img.disabled="true";
  			
		var html=$.ajax({
			url:'printCommentTable.do?id='+$("#id").val()+'',
			success:function(html){
				//if(!html.error){alert("打印失败！");}
				window.opener.location.href='salesBackContractManage.do?init=true';  
				$("#DivTr").hide();
			wb.execwb(6,6);
			$("#DivTr").show();
			}
		});
		
			//window.location.href='printCommentTable.do?id='+$("#id").val()+'';
		} 	
		function closeWindow(){
			wb.execwb(45,1); 
		}
		
	
	</script>
	</head>
<body><br/>
<c:if test="${param.modifyError}">
	<script>alert("打印失败！");</script>
</c:if>
<OBJECT id="wb" height=0 width=0 classid=CLSID:8856F961-340A-11D0-A96B-00C04FD705A2 name="wb"></OBJECT>
<html:form action="printCommentTable" method="post" styleId="commentForm">

<table border="0" cellpadding="0" cellspacing="0" align="center" width="98%" class="tad"><tr><td colspan="2" align="center" height="30"><table border="0" cellpadding="0" cellspacing="0" align="center" width="98%" class="tad">
	<tr>
		<td height="40" colspan="2" valign="top"><table width="100%" cellpadding="0" cellspacing="0">
			<tr>
				<td align="center" class="STYLE1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;同方股份有限公司</td>
				<td width="100">JL-CP-001</td>
			</tr>
			<tr>
				<td colspan="2" align="center" class="STYLE2" height="25px">销售退货合同评审表</td>
			</tr>
		</table></td>
	</tr>
	<tr>
		<td colspan="2"><table width="100%" cellpadding="0" cellspacing="0" class="tad_1">
			<tr>
				<td width="11%" align="center">部门名称</td>
				<td width="38%" align="left">${salesBackContractOfShowDto.productDeptName}&nbsp;</td>
				<td width="13%" align="center">产品合同号</td>
				<td width="38%" align="left">${salesBackContractOfShowDto.productContractCode}&nbsp;</td>
			</tr>
			<tr>
				<td align="center">客户名称</td>
				<td align="left">${salesBackContractOfShowDto.customerName}&nbsp;</td>
				<td align="center">公司合同号</td>
				<td align="left">${salesBackContractOfShowDto.companyContractCode}&nbsp;</td>
			</tr>
			<tr>
				<td align="center">盖章类型</td>
				<td align="left">
				<logic:equal value="0" property="stampType"
										name="salesBackContractOfShowDto">
            		业务章
            	</logic:equal>
									<logic:equal value="1" property="stampType"
										name="salesBackContractOfShowDto">
            		合同章
            	</logic:equal>				
				</td>
				<td align="center">模板类型</td>
				<td align="left">
				<logic:equal value="0" property="templateType"
										name="salesBackContractOfShowDto">
            		标准模板
            	</logic:equal>

				<logic:equal value="1" property="templateType"
										name="salesBackContractOfShowDto">
            		非模板&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            	</logic:equal>
				
				</td>
			</tr>
			<tr>
				<td align="center">产品分类</td>
				<td align="left">${salesBackContractOfShowDto.productTypeName}</td>
				<td align="center">产品序列号</td>
				<td align="left">${salesBackContractOfShowDto.productDeptNo}${salesBackContractOfShowDto.productTypeNo}</td>
			</tr>
		</table></td>
	</tr>
	<tr>
		<td width="50%">&nbsp;</td>
		<td align="right">单位（元）</td>
	</tr>
	<tr>
		<td colspan="2"><table width="100%" cellpadding="0" cellspacing="0" class="tad_1">
			<tr>
				<td align="center"><strong>序号</strong></td>
				<td align="center">产品名称</td>				
				<td align="center"><strong>规格型号</strong></td>
				<td align="center" width="40"><strong>单位</strong></td>
				<td align="center" width="96">销售单价</td>
				<td align="center" width="96"><strong>退货销售合同数量</strong></td>
				
				<td align="center" width="96">退货销售合同总价</td>
			</tr>			
			<logic:present name="goodsInfo">
								<logic:iterate id="goodsInfo" name="goodsInfo"
									indexId="indexId">
									<tr>
										<td nowrap="nowrap " align="left">
											&nbsp;${indexId+1}
										</td>										
										<td nowrap="nowrap" align="left">
											&nbsp;${goodsInfo.productName}
										</td>
										<td nowrap="nowrap" align="left">
											&nbsp;${goodsInfo.specModel}
										</td>
										<td nowrap="nowrap" align="left">
											&nbsp;${goodsInfo.unit}
										</td>
										<td nowrap="nowrap" align="right">
											<fmt:formatNumber value="${goodsInfo.sellPrice}" pattern="#,##0.00"/>&nbsp;
											
										</td>
										<td nowrap="nowrap" align="right">
											${goodsInfo.backContractGoodsCount}&nbsp;
										</td>
										<td nowrap="nowrap" align="right">
										<fmt:formatNumber value="${goodsInfo.backContractGoodsMoney}" pattern="#,##0.00"/>&nbsp;
										</td>										
									</tr>
								</logic:iterate>
							</logic:present>
			<tr>
				<td colspan="7" align="right">总计&nbsp;￥<fmt:formatNumber value="${salesBackContractOfShowDto.money}" pattern="#,##0.00"/>&nbsp;&nbsp;</td>

			</tr>
		</table></td>
	</tr>
	<tr>
		<td colspan="2">
		<table cellpadding="0" cellspacing="0" width="100%" class="tad_2">
			<tr>
				<td style="line-height:22px" align="left" colspan="3">部门送审人送审说明</td>
			</tr>
			<tr>
				<td style="line-height:22px" align="left" colspan="3">1.发票类型：<logic:equal value="0" property="customerInvoiceType" name="salesBackContractOfShowDto">普通</logic:equal><logic:equal value="1" property="customerInvoiceType" name="salesBackContractOfShowDto">增值税</logic:equal></td>
			</tr>
			<tr>
				<td  style="line-height:22px" align="left" colspan="3">2.要求退货时间：${salesBackContractOfShowDto.backDate}</td>
			</tr>
			<tr>
				<td style="line-height:22px" colspan="3" colspan="3"><table cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td  valign="top" align="left" width="120px" nowrap>3.重要事项说明：</td><td align="left">${tf:replaceBr(salesBackContractOfShowDto.text)}</td>
					</tr>
				</table></td>
			</tr>
			<tr>
				<td style="line-height:22px" width="50%">&nbsp;</td>
				<td style="line-height:22px" width="25%" align="left">送审人签字：${salesBackContractOfShowDto.userName}</td>
				<td style="line-height:22px" width="25%" align="left">日期：${salesBackContractOfShowDto.datetime}</td>
			</tr>
		</table></td>
	</tr>
	<c:if test="${salesBackContractOfShowDto.templateType=='1'}">
	<tr>
		<td colspan="2"><table cellpadding="0" cellspacing="0" width="100%" class="tad_2">
			<tr>
				<td colspan="3" style="line-height:22px" align="left">法务专员评审意见</td>
			</tr>
			<tr>
				<td style="line-height:22px" align="left">法律法规是否符合</td>
				<td height="20px" colspan="2" align="left">
					<input type="checkbox" name="salesBackContractOfShowDto.legalIdea"
						id="checkbox4" onclick="return false"
						<c:if test="${salesBackContractOfShowDto.legalIdea == 1}">checked="checked"</c:if> />
					符合 &nbsp;&nbsp;
					<input type="checkbox" name="salesBackContractOfShowDto.legalIdea"
						id="checkbox4" onclick="return false"
						<c:if test="${salesBackContractOfShowDto.legalIdea == 0}">checked="checked"</c:if> />
					不符合
				</td>
			</tr>
			<tr>
				<td colspan="3" style="line-height:22px" align="left"><table cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td width="70" valign="top" align="left">补充说明：</td>
						<td align="left">${tf:replaceBr(salesBackContractOfShowDto.legalText)}</td>
					</tr>
				</table></td>
			</tr>
			<tr>
				<td style="line-height:22px" width="50%">&nbsp;</td>
				<td style="line-height:22px" width="25%" align="left">签字：${salesBackContractOfShowDto.legalName}</td>
				<td style="line-height:22px" width="25%" align="left">日期：${salesBackContractOfShowDto.legalDate}</td>
			</tr>
		</table></td>
	</tr>
	</c:if>
	<tr>
		<td colspan="2"><table cellpadding="0" cellspacing="0" width="100%" class="tad_2">
	 <tr>
          <td colspan="3" style="line-height:22px" align="left">区域总监评审意见：</td>
        </tr>
        <tr>
          <td style="line-height:22px" align="left">1.退货数量是否符合 &nbsp;</td>
          <td height="20px" colspan="2" align="left"> <input type="checkbox" name="checkbox5" id="checkbox5" onclick="return false" 
                <c:if test="${salesBackContractOfShowDto.areaMajIdea1==1}">checked="checked"</c:if>
                />符合
                &nbsp;&nbsp; <input type="checkbox" name="checkbox5" id="checkbox5" onclick="return false"  
                <c:if test="${salesBackContractOfShowDto.areaMajIdea1==0}">checked="checked"</c:if>
                />不符合 
          </td>
        </tr>
        <tr>
          <td style="line-height:22px" align="left">2.退货退款方式是否符合 &nbsp;</td>
          <td height="20px" colspan="2" align="left"> <input type="checkbox" name="checkbox5" id="checkbox5" onclick="return false"  
                <c:if test="${salesBackContractOfShowDto.areaMajIdea2==1}">checked="checked"</c:if>
                />符合
                &nbsp;&nbsp; <input type="checkbox" name="checkbox5" id="checkbox5" onclick="return false"  
                <c:if test="${salesBackContractOfShowDto.areaMajIdea2==0}">checked="checked"</c:if>
                />不符合 
          </td>
        </tr>
        <tr>
          <td style="line-height:22px" align="left">3.退货地址是否符合 &nbsp;</td>
          <td height="20px" colspan="2" align="left"> <input type="checkbox" name="checkbox5" id="checkbox5" onclick="return false"  
                <c:if test="${salesBackContractOfShowDto.areaMajIdea3==1}">checked="checked"</c:if>
                />符合
                &nbsp;&nbsp; <input type="checkbox" name="checkbox5" id="checkbox5" onclick="return false"  
                <c:if test="${salesBackContractOfShowDto.areaMajIdea3==0}">checked="checked"</c:if>
                />不符合  
          </td>
        </tr>
        <tr>
          <td colspan="2">
                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                  <tr>
                    <td width="70" valign="top">补充说明：</td>
                    <td align="left">${tf:replaceBr(salesBackContractOfShowDto.areaMajText)}</td>
                  </tr>
                </table>
          </td>
        </tr>
        <tr>
       	 <td style="line-height:22px" width="50%">&nbsp;</td>
          <td style="line-height:22px" width="25%" align="left">签字：${salesBackContractOfShowDto.areaMajName }</td>
          <td style="line-height:22px" width="25%" align="left">日期：${salesBackContractOfShowDto.areaMajDate }</td>
        </tr>
        </table></td>
			</tr>	
        <tr>
          <td height="20px" colspan="2">&nbsp;</td>
        </tr>
  	  			<c:if test="${salesBackContractOfShowDto.sellMajIdea!=null && fn:substring(salesBackContractOfShowDto.sellMajIdea,0,1)==0}">
					<c:set value="checked" var="sellCountUnpass" scope="page"></c:set>
				</c:if>
				<c:if test="${salesBackContractOfShowDto.sellMajIdea!=null && fn:substring(salesBackContractOfShowDto.sellMajIdea,0,1)==1}">
					<c:set value="checked" var="sellCountPass" scope="page"></c:set>
				</c:if> 
				
				<c:if test="${salesBackContractOfShowDto.sellMajIdea!=null && fn:substring(salesBackContractOfShowDto.sellMajIdea,1,2)==0}">
					<c:set value="checked" var="sellQuomodoUnpass" scope="page"></c:set>
				</c:if>
				<c:if test="${salesBackContractOfShowDto.sellMajIdea!=null && fn:substring(salesBackContractOfShowDto.sellMajIdea,1,2)==1}">
					<c:set value="checked" var="sellQuomodoPass" scope="page"></c:set>
				</c:if> 
				
				<c:if test="${salesBackContractOfShowDto.sellMajIdea!=null && fn:substring(salesBackContractOfShowDto.sellMajIdea,2,3)==0}">
					<c:set value="checked" var="sellAddressUnpass" scope="page"></c:set>
				</c:if>
				<c:if test="${salesBackContractOfShowDto.sellMajIdea!=null && fn:substring(salesBackContractOfShowDto.sellMajIdea,2,3)==1}">
					<c:set value="checked" var="sellAddressPass" scope="page"></c:set>
				</c:if> 
	<tr>
		<td colspan="2"><table cellpadding="0" cellspacing="0" width="100%" class="tad_2">
			<tr>
				<td colspan="3" style="line-height:22px" align="left">销售总监评审意见</td>
			</tr>
			<tr>
				<td style="line-height:22px" align="left">1.退货数量是否符合 &nbsp;</td>
				<td height="20px" colspan="2" align="left">
					<input type="checkbox" name="checkbox5" id="checkbox5" onclick="return false" <c:out value="${sellCountPass}"></c:out>/>符合
				  				&nbsp;&nbsp;
					<input type="checkbox" name="checkbox5" id="checkbox5" onclick="return false" <c:out value="${sellCountUnpass}"></c:out>/>不符合
				</td>
			</tr>
			<tr>
				<td style="line-height:22px" align="left">2.退货退款方式是否符合 &nbsp;</td>
				<td height="20px" colspan="2" align="left">
	  				<input type="checkbox" name="checkbox5" id="checkbox5" onclick="return false" <c:out value="${sellQuomodoPass}"></c:out>/>符合
		  				&nbsp;&nbsp;
					<input type="checkbox" name="checkbox5" id="checkbox5" onclick="return false" <c:out value="${sellQuomodoUnpass}"></c:out>/>不符合
				</td>
			</tr>
			<tr>
				<td style="line-height:22px" align="left">3.退货地址是否符合 &nbsp;</td>
				<td height="20px" colspan="2" align="left">
	  				<input type="checkbox" name="checkbox5" id="checkbox5" onclick="return false" <c:out value="${sellAddressPass}"></c:out>/>符合
		  				&nbsp;&nbsp;
					<input type="checkbox" name="checkbox5" id="checkbox5" onclick="return false" <c:out value="${sellAddressUnpass}"></c:out>/>不符合
				</td>
			</tr>
			<tr>
				<td colspan="3" style="line-height:22px"><table cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td width="70" valign="top" >补充说明：</td>
						<td align="left">${tf:replaceBr(salesBackContractOfShowDto.sellMajText)}</td>
					</tr>
				</table></td>
			</tr>	
			<tr>
				<td style="line-height:22px" width="50%">&nbsp;</td>
				<td style="line-height:22px" width="25%" align="left">签字：${salesBackContractOfShowDto.sellMajName}</td>
				<td style="line-height:22px" width="25%" align="left">日期：${salesBackContractOfShowDto.sellMajDate}</td>
			</tr>
		</table></td>
	</tr>
	<tr>
		<td colspan="2"><table cellpadding="0" cellspacing="0" width="100%" class="tad_2">
			<tr>
				<td colspan="3" style="line-height:22px" align="left">运营总监评审意见</td>
			</tr>
			<tr>
				<td style="line-height:22px">&nbsp;</td>
				<td height="20px" colspan="2" align="left">
									<input type="checkbox" name="salesBackContractOfShowDto.opeMajIdea"
										id="checkbox4" onclick="return false"
										<c:if test="${salesBackContractOfShowDto.opeMajIdea == 1}">checked="checked"</c:if> />
									同意 &nbsp;&nbsp;
									<input type="checkbox" name="salesBackContractOfShowDto.opeMajIdea"
										id="checkbox4" onclick="return false"
										<c:if test="${salesBackContractOfShowDto.opeMajIdea == 0}">checked="checked"</c:if> />
									不同意
				</td>
			</tr>
			<tr>
				<td colspan="3" style="line-height:22px"><table cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td width="70" valign="top">补充说明：</td>
						<td align="left">${tf:replaceBr(salesBackContractOfShowDto.opeMajText)}</td>
					</tr>
				</table></td>
			</tr>
			<tr>
				<td style="line-height:22px" width="50%">&nbsp;</td>
				<td style="line-height:22px" width="25%" align="left">签字：${salesBackContractOfShowDto.opeMajName}</td>
				<td style="line-height:22px" width="25%" align="left">日期：${salesBackContractOfShowDto.opeMajDate}</td>
			</tr>
		</table></td>
	</tr>
	<tr>
		<td colspan="2"><table cellpadding="0" cellspacing="0" width="100%" class="tad_2">
			<tr>
				<td colspan="3" style="line-height:22px" align="left">公司授权领导最终审批意见</td>
			</tr>
			<tr>
				<td style="line-height:22px">&nbsp;</td>
				<td colspan="2" align="left"><input type="checkbox" name="checkbox9" id="checkbox10" onclick="return false"/>
					同意
					&nbsp;&nbsp;
											<input type="checkbox" name="checkbox9" id="checkbox10" onclick="return false"/>
					不同意</td>
			</tr>
			<tr>
				<td colspan="3" style="line-height:22px"><table cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td width="70" valign="top">&nbsp;</td>
						<td>&nbsp;</td>
					</tr>
				</table></td>
			</tr>
			<tr>
				<td style="line-height:22px" width="50%">&nbsp;</td>
				<td style="line-height:22px" width="25%" align="left">签字：</td>
				<td style="line-height:22px" width="25%" align="left">日期：</td>
			</tr>
			
		</table></td>
	</tr>
	<c:if test="${requestScope.print}"></c:if>
	<tr id="DivTr">
		<td colspan="2" align="center" height="50px">
			<c:choose>
				<c:when test="${requestScope.print}">
				<!-- <a href="#" onclick="javascript:return printIt();">
						<img src="${ctx}/images/btnPrint.gif" width="65" height="20" /></a>  -->
				<img src="${ctx}/images/btnPrint.gif" width="65" height="20" onClick="printIt(this)"/>
				</c:when>	
				<c:otherwise>
					<a href="#" id="printOfshow">
						<img src="${ctx}/images/btnPrint.gif" width="65" height="20" /></a>
				</c:otherwise>
			</c:choose>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<a href="#" onclick="javascript:printSetup();">
			<img src="${ctx}/images/btnPrintSZ.gif" width="88" height="20" /></a>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<a href="#" onclick="javascript:printPreview();">
			<img src="${ctx}/images/btnPrintYL.gif" /></a>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	
		</td>
	</tr>
	
</table>
<input  type="hidden" value="${param.id	}" name="id" id="id"/>
</html:form>
</body>
</html>
