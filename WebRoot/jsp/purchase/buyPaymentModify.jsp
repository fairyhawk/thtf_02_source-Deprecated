<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ include file="/jsp/common/taglibs.jsp"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@taglib prefix="tf" uri="localhost" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>付款修改</title>
<link href="${ctx}/css/css.css" rel="stylesheet" type="text/css" />
<link href="${ctx}/css/input.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${ctx}/js/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="${ctx}/js/jquery.validate.min.js"></script>
<script type="text/javascript" src="${ctx}/js/common/common.js"></script>
<style type="text/css">
<!--
.STYLE1 {
	color: #FF0000
}
.treven {
	background-color: #f3fbff;
}
.over {
	background-color: #ECECEC;
}
-->
</style>
<script language="JavaScript">
<!--
$(document).ready(function(){
				$.ajaxSetup({ 
  					async: false 
  				}); 
  				var subwin;
				window.onbeforeunload=function()
			    { 
			        if(subwin!=undefined){
			            subwin.close();
			        }
			    }
				if($("#table")){
					$("#table tr:even").addClass("treven");
					$("#table tr").each(function(i){
						$(this).mouseover(function(){
							$(this).addClass("over");
						});
						$(this).mouseout(function(){
							$(this).removeClass("over");
						});
					});
				}
				//提交
				$('#btnCreate').click(function(){
					$('#btnClick').val('1');
					$('#buyPaymentAddForm').submit();
					//$.post('buyPaymentAdd.do',$('#buyPaymentAddForm').serializeArray() ,waitResult,'html');
				});
				
				//保存
				$('#btnSave').click(function(){
					$('#btnClick').val('0');
					$('#buyPaymentAddForm').submit();
					//$.post('buyPaymentAdd.do',$('#buyPaymentAddForm').serializeArray() ,waitResult,'html');
				});
				
				//返回
				$('#backBtn').click(function(){
					document.location.href='buyPayment.do';
				});
				
				//验证
				$('#buyPaymentAddForm').validate({
					rules: { 
						"supplierIdv":"required",
						"supplierLinkman":"required",
						"paymentWay":"required",
						"productTypeId":"required",
						"arterm":{required:true,digits:true}
					},
					messages: {
						"supplierIdv":"请选择供货商",
						"supplierLinkman":"请选择供货商联系人",
						"paymentWay":"请选择付款方式",
						"productTypeId":"请选择产品分类",
						"arterm":{required:"请输入帐期",digits:"帐期必须是数字"}
					} ,
					submitHandler:function(){
						if($('#inStock tr').length==0&&$('#buyContract tr').length==0){
							alert('请添加合同信息或产品信息！');
							return false;
						}
						var validateMart;
						//预付金额<=合同金额-已预付金额-退货合同金额
						if($('#buyContract tr').length > 0){
							$('#buyContract tr').each(function(i){
								var buyContractMoney = rmoney($(this).children("td:eq(4)").text()),
									alreadyAdvanceMoney = rmoney($(this).children("td:eq(7)").text()),
									backGoodMoney = rmoney($(this).children("td:eq(9)").text()),validateMoney;
								var advanceMoney = $(this).children("td:eq(11)").find('input').val(); 
								 
								validateMoney = FloatSub(advanceMoney,FloatSub(FloatSub(buyContractMoney,alreadyAdvanceMoney),backGoodMoney));
								//alert(advanceMoney+'+_+'+buyContractMoney+'____'+validateMoney);
								//return false;
								$(this).children("td:eq(11)").find('input').val(advanceMoney);
								var regExp = /^[0-9]+\d*[\.\d]?\d{0,5}$/;
								if (regExp.test(advanceMoney) == false||advanceMoney==0) {
									alert('请输入正确的预付金额！');
									validateMart = false;
									return false;
								}
								if(validateMoney>0){
									validateMart = false;
									alert('预付金额<=合同金额-已预付金额-退货合同金额！');
									return false;
								}
								validateMart = true;
							}); 
							if(!validateMart){
								return validateMart;
							}
						}
						//指定金额<=入库金额-已指定金额-返厂金额
						if($('#inStock tr').length > 0){
							$('#inStock tr').each(function(i){
								var inStockMoney = rmoney($(this).children("td:eq(11)").text()),
									alreadyAppointMoney = rmoney($(this).children("td:eq(12)").text()),
									backMoney = rmoney($(this).children("td:eq(14)").text()),validateMoney;
								var appointMoney = $(this).children("td:eq(15)").find('input').val(); 
								 
								validateMoney = FloatSub(appointMoney,FloatSub(FloatSub(inStockMoney,alreadyAppointMoney),backMoney));

								$(this).children("td:eq(15)").find('input').val(appointMoney);
								var regExp = /^[0-9]+\d*[\.\d]?\d{0,5}$/;
								if (regExp.test(appointMoney) == false||appointMoney==0) {
									alert('请输入正确的指定金额！');
									validateMart = false;
									return false;
								}
								if(validateMoney>0&&$('#contractType').val()=='0'){
									validateMart = false;
									alert('指定金额<=入库金额-已指定金额-返厂金额！');
									return false;
								}
								validateMart = true;
							});
							if(!validateMart){
								return validateMart;
							}
						}
						$.post('modifyBuyPayment.do',$('#buyPaymentAddForm').serializeArray() ,waitResult,'html');
					},
					errorClass: "invalid"
				});
				
				//初始化联系人
				var url = 'getSupplierLinkMan.do?supplierId='+$('#supplierId').val();
				$.getJSON(url,function waitReturnResult(date){
					var option = '<option value="">--请选择--</option>';
					$('#supplierLinkman option').remove();
					$.each(date,function(i,linkman){
						optionValue = linkman.id+'#'+linkman.tel+'#'+linkman.fax;
						if(linkman.id == ${bpid.supplierLinkmanId}){
							option = option + '<option value="'+optionValue+'" selected="true">'+linkman.name+'</option>';
						}else{
							option = option + '<option value="'+optionValue+'" >'+linkman.name+'</option>';
						}
					});
					//添加供货商联系人下拉框
					$('#supplierLinkman').html(option);
				});
				
				//初始化金额
				changeCount('inStockDelete');
				changeCount('buyContractDelete');
				
				//初始化付款方式
				$('#paymentWay option[value="${bpid.paymentWay}"]').attr('selected',true);
				if(${bpid.paymentWay} == 5){
					$('#paymentWayChange0').text('帐期');
					$('#paymentWayChange1').html('<input type="text" name="arterm" id="arterm" maxlength="3" style="width:120px;" value="${bpid.arterm}"/> 天');
				}
				
				//初始化产品分类
				$('#productTypeId option[value="${bpid.productTypeId}"]').attr('selected',true);
				
				//初始化发票类型
				if('${bpid.supplierInvoiceType}'=='0'){
					$('#supplierInvoiceType').text("普通");
				}
				if('${bpid.supplierInvoiceType}'=='1'){
					$('#supplierInvoiceType').text("增值税");
				}
				
				//初始化评审意见
				//产品总监评审意见
		        if('${ProMajIder[0]}'=='1'){
		        	$('#checkbox1').attr("checked",'true');
		        }
		        if('${ProMajIder[0]}'=='0'){
		        	$('#checkbox2').attr("checked",'true');
		        }
		        if('${ProMajIder[1]}'=='1'){
		        	$('#checkbox3').attr("checked",'true');
		        }
		        if('${ProMajIder[1]}'=='0'){
		        	$('#checkbox4').attr("checked",'true');
		        }
		        if('${ProMajIder[2]}'=='1'){
		        	$('#checkbox5').attr("checked",'true');
		        }
		        if('${ProMajIder[2]}'=='0'){
		        	$('#checkbox6').attr("checked",'true');
		        }
		        if('${ProMajIder[3]}'=='1'){
		        	$('#checkbox7').attr("checked",'true');
		        }
		        if('${ProMajIder[3]}'=='0'){
		        	$('#checkbox8').attr("checked",'true');
		        }
		        if('${ProMajIder[4]}'=='1'){
		        	$('#checkbox9').attr("checked",'true');
		        }
		        if('${ProMajIder[4]}'=='0'){
		        	$('#checkbox10').attr("checked",'true');
		        }
		        //采购主管评审意见
		        if('${bpid.buyManIdea}'=='1'){
		        	$('#buyManIdea1').attr("checked",'true');
		        }
		        if('${bpid.buyManIdea}'=='0'){
		        	$('#buyManIdea0').attr("checked",'true');
		        }
		        //运营总监评审意见
		        if('${bpid.opeMajIder}'=='1'){
		        	$('#opeMajIder1').attr("checked",'true');
		        }
		        if('${bpid.opeMajIder}'=='0'){
		        	$('#opeMajIder0').attr("checked",'true');
		        }
				
				//供货商联系人选择
				$('#supplierLinkman').change(function(){
					var array = new Array();
					if($(this).val()!=''){
						array = $(this).val().split('#');
						$('#tel').text(array[1]);
						$('#fax').text(array[2]);
						$('#supplierLinkmanId').val(array[0]);
					}else{
						$('#tel').text(' ');
						$('#fax').text(' ');
						$('#supplierLinkmanId').val(' ');
					}
				});
				
				//帐期显示
				$('#paymentWay').change(function(){
					if($(this).val()==5){
						$('#paymentWayChange0').text('帐期');
						$('#paymentWayChange1').html('<input type="text" name="arterm" id="arterm" maxlength="3" style="width:120px;" /> 天');
					}else{
						$('#paymentWayChange0').text(' ');
						$('#paymentWayChange1').html(' ');
					}
				});
				
				//换供货商
				$('#clickSupplier').click(function(){
					if($('#buyContract #buyContractId').length!=0||$('#inStock #inStockIdAndProductId').length!=0){
						alert("已选择合同或入库明细后不能改变！");
						return false;
					}
					subwin = window.open('buyPaymentSelectSupplier.do','newwindow', 'toolbar=no,scrollbars=yes,resizable=no,top=200,left=370, width=900,height=430');
				});
				
				//换产品分类验证
			 	var stockChange =1;
			 	var productTypeIdText = $('#productTypeId').val();
				$('#productTypeId').change(function(){ 
					if($('#buyContract #buyContractId').length!=0||$('#inStock #inStockIdAndProductId').length!=0){  
						if(stockChange==1){
					 		stockChange = 2;
					 		$('#productTypeId').attr('value',productTypeIdText);
							alert("已选择合同或入库明细后不能改变！");
					 	}
					 	if(stockChange==2){
					 		stockChange = 1;
						}
					}
					productTypeIdText = $(this).val();
				});
				
				//采购合同选择小页面
				$('#selectBuyC').click(function(){
					if($('#contractType').val()=='0')
					{
						var url = 'buyPaymentSelectBuyContract.do';
						var supplierId = $('#supplierId').val();
						var productTypeId = $('#productTypeId').val();
						if(supplierId==''||productTypeId==''){
							alert('请选择供货商和产品分类！');
							return false;
						}
						url=url+'?supplierId='+supplierId+'&productTypeId='+productTypeId;
						//alert(url);
						subwin = window.open(url,'newwindow', 'toolbar=no,scrollbars=yes,resizable=no,top=200,left=370, width=900,height=430');
					}else{
						alert('外单不允许预付！');
					}
				});
				
				//入库明细选择小页面
				$('#btnAddInStock').click(function(){
					var url = 'buyPaymentSelectInStockDetail.do';
					var supplierId = $('#supplierId').val();
					var productTypeId = $('#productTypeId').val();
					if(supplierId==''||productTypeId==''){
						alert('请选择供货商和产品分类！');
						return false;
					}
					url=url+'?supplierId='+supplierId+'&productTypeId='+productTypeId;
					//alert(url);
					window.open(url,'newwindow', 'toolbar=no,scrollbars=yes,resizable=no,top=200,left=370, width=1200,height=430');
				});
				
				//合同全选
				 $('#allchecked').click(function(){ 
					if($(this).attr('checked')){
						$('#buyContract :checkbox').attr('checked', true);
					}else{
						$('#buyContract :checkbox').attr('checked', false);
					} 
				 });
				 
				 //入库全选
				 $('#allcheckedInStock').click(function(){ 
					if($(this).attr('checked')){
						$('#inStock :checkbox').attr('checked', true);
					}else{
						$('#inStock :checkbox').attr('checked', false);
					} 
				 });
				
				//删除合同
				$('#deleteBuyC').click(function(){ 
			 	if($('#buyContract tr').length==0){
					alert("请先选择要删除的合同");
			 	}else{  
					var i = 0;
					$('#buyContract :checkbox').each(function(){  
						if($(this).attr("checked")){
							$('#buyContract tr:eq('+(i--)+')').remove();
						}
						i++;
					}); 
					changeCountBuy();
					if($('#buyContract')){
						$('#buyContract tr').removeClass('treven');
						$('#buyContract tr:even').addClass('treven'); 
					}
				}
				$('#allchecked').attr('checked',false);
				});
				
				//删除入库明细
				$('#btnDeleteInstock').click(function(){ 
			 	if($('#inStock tr').length==0){
					alert("请先选择要删除的入库明细");
			 	}else{  
					var i = 0;
					$('#inStock :checkbox').each(function(){  
						if($(this).attr("checked")){
							$('#inStock tr:eq('+(i--)+')').remove();
						}
						i++;
					}); 
					changeCountInStock();
					
					if($('#inStock')){
						$('#inStock tr').removeClass('treven');
						$('#inStock tr:even').addClass('treven'); 
					}
				}
				$('#allcheckedInStock').attr('checked',false);
				});
			});
			//供货商选择
			function addSupplier(supplier){
				var array = new Array();
				array = supplier.split("\\||//");
				$('#supplierName').text(array[1]);
				$('#supplierProvince').text(array[2]);
				$('#supplierCity').text(array[3]);
				$('#supplierInvoiceType').text(array[4]);
				$('#supplierTaxRate').text(array[5]+'%');
				$('#remitBankName').text(array[6]);
				$('#remitBankAccount').text(array[7]);
				$('#contractType').val(array[8]);
				$('#supplierId').val(array[0]);
				$('#supplierIdName').val(array[1]);

				$('#tel').text(' ');
				$('#fax').text(' ');
				$('#supplierLinkmanId').val(' ');
				var url = 'getSupplierLinkMan.do?supplierId='+array[0];
				$.getJSON(url,function waitResult(date){
					var option = '<option value="">--请选择--</option>';
					$('#supplierLinkman option').remove();
					$.each(date,function(i,linkman){
						optionValue = linkman.id+'#'+linkman.tel+'#'+linkman.fax;
						option = option + '<option value="'+optionValue+'">'+linkman.name+'</option>';
					});
					//添加供货商联系人下拉框
					$('#supplierLinkman').html(option);
				});
			}
			
			//添加采购合同
			function addProductC(bcArray){
				$.each(bcArray,function(i,buyC){ 
					var tr = $("<tr></tr>").appendTo('#buyContract'),buycArray = new Array();
					buycArray = buyC.split('\\||//');
					tr.append('<td style="border-left:1px solid #c2c2c2;"><input type="hidden" name="buyContractId" id="buyContractId" value="'+buycArray[0]+'" /><input type="checkbox" /></td>').append("<td>"+(i+1)+"</td>"); 
					$.each(buycArray,function(j,td){
						if(td==""){
							td=0;
						}
						if(j==3||j==4||j==5||j==6||j==7||j==8){
							tr.append('<td style="width:86px; text-align:right">'+formatMoney(td,5)+'&nbsp;</td>'); 
						}
						else if(j==9){
							tr.append('<td style="width:86px; text-align:right">'+formatMoney(td,5)+'&nbsp;</td>'); 
							tr.append('<td style="text-align:right"><input type="text" name="advanceMoney" id="advanceMoney" style="width:86px; text-align:right" onchange="javascript:changeCount(this.id);" value="0" />&nbsp;&nbsp;</td>');
						}else if(j==0){
						
						}
						else{
							tr.append("<td>"+td+"</td>"); 
						}
						
					});
					changeCountBuy();
				}); 
			}
			
			//判断合同小页面传过来的合同是否存在
			function checkbuyC(bcArray){
				if($('#buyContract #buyContractId').length==0){
					return false;
				}else{
					var result;
					$('#buyContract #buyContractId').each(function(i){
						if($(this).val()==bcArray.split('\\||//')[0]){
							result = true;
						}
					});
					return result;
				} 
			}
			//计算合同信息金额
			function changeCountBuy(){
				$('#buyContract tr').each(function(i){
					$(this).children('td:eq(1)').text(i+1);
				}); 
				changeCount('buyContractDelete');
			}
			
			//计算产品信息金额
			function changeCountInStock(){
				$('#inStock tr').each(function(i){
					$(this).children('td:eq(1)').text(i+1);
				}); 
				changeCount('inStockDelete');
			}
			
			//入库明细选择小页面产品分类名称
			function getProductTypeName(){
				var productTypeName = $('#productTypeId option:selected').text();
				return productTypeName;
			}
			
			//添加入库明细
			function addInStockD(arraySan){
				$.each(arraySan,function(i,instockD){ 
					var tr = $("<tr></tr>").appendTo('#inStock'),insdArray = new Array();
					insdArray = instockD.split('\\||//');
					tr.append('<td style="border-left:1px solid #c2c2c2;"><input type="hidden" name="inStockIdAndProductId" id="inStockIdAndProductId" value="'+insdArray[0]+'#'+insdArray[13]+'" /><input type="hidden" name="inStockId" id="inStockId" value="'+insdArray[0]+'" /><input type="hidden" name="productId" id="productId" value="'+insdArray[13]+'" /><input type="hidden" name="inStockBuyBuyContractId" id="inStockBuyBuyContractId" value="'+insdArray[14]+'" /><input type="checkbox" /></td>').append("<td>"+(i+1)+"</td>"); 
					$.each(insdArray,function(j,td){
						if(td==""){
							td=0;
						}
						if(j==8||j==9||j==10||j==11){
							tr.append('<td style="width:86px; text-align:right">'+formatMoney(td,5)+'&nbsp;</td>'); 
						}
						else if(j==12){
							tr.append('<td style="width:86px; text-align:right">'+formatMoney(td,5)+'&nbsp;</td>'); 
							tr.append('<td style="text-align:right"><input type="text" name="appointMoney" id="appointMoney" style="width:86px; text-align:right" onchange="javascript:changeCount(this.id);" value="0" />&nbsp;&nbsp;</td>');
						}
						else if(j==13){
						}
						else if(j==14){
						}
						else{
							tr.append("<td>"+td+"</td>"); 
						}
					});
					changeCountInStock();
				}); 
			}
			
			//判断小页面传过来的合同是否存在
			function checkInStockD(insArray){
				if($('#inStock #inStockIdAndProductId').length==0){
					return false;
				}else{
					var result;
					$('#inStock #inStockIdAndProductId').each(function(i){
						var insValue = insArray.split('\\||//')[0]+'#'+insArray.split('\\||//')[13];
						if($(this).val()==insValue){
							result = true;
						}
					});
					return result;
				} 
			}
			
			//获取服务器返回结果
			function waitResult(date){
				var result = new Array(),text;
				result = date.split(',');
				if(result[0]=='1'){
					text = '提交失败！';
				}else if(result[0]=='0'){
					text = '保存失败！';
				}else if(result[0]=='2'){
					text = '错误：合同[产品合同号]的付款金额超过应付金额';
				}
				if(result[1]=='true'){
					document.location.href = 'buyPayment.do';
				}else{
					alert(text);
				}
			}
			//计算金额
			function changeCount(mart){
				var appointMoney,moneyE=0,sumMoney = 0;
				if(mart=='appointMoney'||mart=='inStockDelete'){
					$('#inStock tr').each(function(i){
						appointMoney = $(this).children("td:eq(15)").find('input').val();
						moneyE = FloatAdd(moneyE,appointMoney);
					}); 
					$('#appointMoneyE').text(formatMoney(moneyE,5));
				}else if(mart=='advanceMoney'||mart=='buyContractDelete'){
					$('#buyContract tr').each(function(i){
						appointMoney = $(this).children("td:eq(11)").find('input').val();
						moneyE = FloatAdd(moneyE,appointMoney);
					}); 
					$('#advanceMoneyE').text(formatMoney(moneyE,5));
				}
				//付款金额计算
				sumMoney = FloatAdd(rmoney($('#advanceMoneyE').text()),rmoney($('#appointMoneyE').text()));
				$('#sumMoney').text(''.concat(formatMoney(sumMoney,5)).concat('元'));
				$('#money').val(sumMoney);
				//隔行换色
				if($("#table")){
					$("#table tr:even").addClass("treven");
					$("#table tr").each(function(i){
						$(this).mouseover(function(){
							$(this).addClass("over");
						});
						$(this).mouseout(function(){
							$(this).removeClass("over");
						});
					});
				}
			}
			//还原金额   
		function rmoney(s){ 
			return parseFloat(s.replace(/[^\d\.-]/g,""));  
		} 

		//金额的格式化s为要格式化的参数（浮点型），n为小数点后保留的位数	
		function formatMoney(s,n){
			n = n>0 && n<=20 ? n : 2;
			s = parseFloat((s+"").replace(/[^\d\.-]/g,"")).toFixed(n)+"";
			var l = s.split(".")[0].split("").reverse(), 
			r = s.split(".")[1]; 
			t = "";
			for(i = 0;i<l.length;i++){
				t+=l[i]+((i+1)%3==0 && (i+1) != l.length ? "," : ""); 
			}
			return t.split("").reverse().join("")+"."+r;
		}
//-->
</script>
<script type="text/javascript" src="${ctx}/js/tad_bs2.js"></script>
</head>
<body>
<form action="buyPaymentAdd.do" name="buyPaymentAddForm" id="buyPaymentAddForm"> 
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td class="ye_header_left">&nbsp;</td>
    <td class="ye_header_center"><img src="${ctx}/images/main_jt.jpg" /> &nbsp;当前位置： 采购管理 &gt;&gt; 付款管理 &gt;&gt; 付款修改</td>
    <td class="ye_header_right">&nbsp;</td>
  </tr>
  <tr>
    <td >&nbsp;</td>
    <td><br />
      <div class="div_tiao"> &nbsp;&nbsp;供货商信息 </div>
      <input type="hidden" id="paymentId" name="paymentId" value="${id}" />
      <input type="hidden" id="supplierIdName" name="supplierName" value="${bpid.supplierName}" />
      <input type="hidden" id="btnClick" name="btnClick" value=""> 
      <input type="hidden" id="money" name="money" value="${bpid.money}">
      <input type="hidden" id="supplierId" name="supplierId" value="${bpid.supplierId}" />
      <input type="hidden" id="contractType" name="contractType" value="${bpid.contractType}" />
      <table width="100%" border="0" cellpadding="0" cellspacing="0" class="biao3">
        <tr>
          <td class="td_01" height="18px" width="20%"><a id="clickSupplier"><img src="${ctx}/images/btnGHSXZ.gif" width="89" height="20" /></a> </td>
          <td class="td_02" width="30%" id="supplierName">${bpid.supplierName}<input type="hidden" id="supplierIdv" name="supplierIdv" value="${bpid.supplierId}" />&nbsp;</td>
          <td class="td_01" width="20%"><span style="color:#FF0000">*</span>&nbsp;联系人</td>
          <td class="td_02" width="30%">
          	<input type="hidden" name="supplierLinkmanId" id="supplierLinkmanId" value="${bpid.supplierLinkmanId}" />
          	<select name="supplierLinkman" id="supplierLinkman" onchange=""  style="width:126px">
              <option value="">--请选择--</option>
            </select></td>
        </tr>
        <tr>
          <td class="td_01" height="18px">省份</td>
          <td class="td_02" id="supplierProvince">${bpid.supplierProvince}&nbsp;</td>
          <td class="td_01">电话</td>
          <td class="td_02" id="tel">${bpid.linkmanTel}&nbsp;</td>
        </tr>
        <tr>
          <td class="td_01" height="18px">城市</td>
          <td class="td_02" id="supplierCity">${bpid.supplierCity}&nbsp;</td>
          <td class="td_01">传真</td>
          <td class="td_02" id="fax">${bpid.linkmanFax}&nbsp;</td>
        </tr>
        <tr>
          <td class="td_01" height="18px">汇款银行名称</td>
          <td class="td_02" id="remitBankName">${bpid.supplierRemitBankName}&nbsp;</td>
          <td class="td_01">汇款银行帐号</td>
          <td class="td_02" id="remitBankAccount">${bpid.supplierRemitBankAccount}&nbsp;</td>
        </tr>
        <tr>
          <td class="td_01" height="18px">发票类型</td>
          <td class="td_02" id="supplierInvoiceType">&nbsp;</td>
          <td class="td_01">增值税税率</td>
          <td class="td_02" id="supplierTaxRate">${bpid.supplierTaxRate}%</td>
        </tr>
      </table>
      <br />
      <div class="div_tiao"> &nbsp;&nbsp;付款信息 </div>
      <table width="100%" border="0" cellpadding="0" cellspacing="0" class="biao3">
        <tr>
          <td class="td_01" width="20%"><span style="color:#FF0000">*</span>&nbsp;付款方式</td>
          <td class="td_02" width="30%">
          	<html:select styleId="paymentWay"  property="paymentWay" value="" style="width:126px">
				<html:option value="">--请选择--</html:option> 
				<html:option value="2">支票</html:option>
                <html:option value="3">网银</html:option>
                <html:option value="4">电汇</html:option>
                <html:option value="5">银行承兑</html:option>
                <html:option value="6">信用证</html:option>
                <html:option value="7">其他</html:option>
			</html:select>
          </td>
          <td class="td_01" width="20%" id="paymentWayChange0">&nbsp;</td>
          <td class="td_02" width="30%" id="paymentWayChange1" >&nbsp;</td>
        </tr>
        <tr>
          <td class="td_01" height="18px">付款金额</td>
          <td class="td_02" id="sumMoney"><fmt:formatNumber value="${bpid.money}" pattern="#,##0.00000#"/>元</td>
          <td class="td_01">产品分类名称</td>
          <td class="td_02" >
         		<html:select styleId="productTypeId" property="productTypeId" value="" style=" width:126px">
					<html:option value="">--请选择--</html:option> 
					<html:options collection="producttypelist" property="id" labelProperty="name"/>
				</html:select>
		  </td>
        </tr>
      </table>
      <br />
      <div class="div_tiao"> &nbsp;&nbsp;采购合同信息 </div>
      <div style="width:100%; text-align:right">单位：元</div>
      <table width="100%" border="0" cellpadding="0" cellspacing="0" class="biao1" id="table" style="border-left:1px solid #FFFFFF;">
        <thead>
          <tr>
            <th nowrap="nowrap" style="border-left:1px solid #c2c2c2;">选择</th>
            <th nowrap="nowrap" width="30">序号</th>
            <th nowrap="nowrap">产品合同号</th>
            <th nowrap="nowrap">公司合同号</th>
            <th nowrap="nowrap">合同金额</th>
            <th nowrap="nowrap">入库金额</th>
            <th nowrap="nowrap">指定金额</th>
            <th nowrap="nowrap">已预付金额</th>
            <th width="90" nowrap="nowrap">收票金额</th>
            <th width="90" nowrap="nowrap">退货合同金额</th>
            <th width="90" nowrap="nowrap">返厂金额</th>
            <th nowrap="nowrap" width="108">预付金额</th>
          </tr>
        </thead>
        <tbody id="buyContract">
        	<logic:iterate id="BuyContract" name="BuyContractList" indexId="index">
		          <tr>
		          	<td  style="border-left:1px solid #c2c2c2;">
		          		<input type="hidden" name="buyContractId" id="buyContractId" value="${BuyContract.buyContractId}" />
		          		<input type="checkbox"  />
		          	</td>
		            <td width="40" nowrap="nowrap"  height="18">${index+1}&nbsp;</td>
		            <td nowrap="nowrap" >${BuyContract.productContractCode}&nbsp;</td>
		            <td nowrap="nowrap" >${BuyContract.companyContractCode}&nbsp;</td>
		            <td nowrap="nowrap" style=" text-align:right;"><fmt:formatNumber value="${BuyContract.contractMomey}" pattern="#,##0.00000#"/>&nbsp;</td>
		            <td nowrap="nowrap" style=" text-align:right;"><fmt:formatNumber value="${BuyContract.inStockMoney}" pattern="#,##0.00000#"/>&nbsp;</td>
		            <td nowrap="nowrap" style=" text-align:right;"><fmt:formatNumber value="${BuyContract.zdMoney}" pattern="#,##0.00000#"/>&nbsp;</td>
		            <td nowrap="nowrap" style=" text-align:right;"><fmt:formatNumber value="${BuyContract.yysMoney}" pattern="#,##0.00000#"/>&nbsp;</td>
		            <td nowrap="nowrap" style=" text-align:right;"><fmt:formatNumber value="${BuyContract.spMoney}" pattern="#,##0.00000#"/>&nbsp;</td>
		            <td nowrap="nowrap" style=" text-align:right;"><fmt:formatNumber value="${BuyContract.backContractMoney}" pattern="#,##0.00000#"/>&nbsp;</td>
		            <td nowrap="nowrap" style=" text-align:right;"><fmt:formatNumber value="${BuyContract.fcMoney}" pattern="#,##0.00000#"/>&nbsp;</td>
		            <td style="text-align:right"><input type="text" name="advanceMoney" id="advanceMoney" style="width:90px; text-align:right" onchange="javascript:changeCount(this.id);" value="${BuyContract.yfMoney}" />&nbsp;&nbsp;</td>
		          </tr>
	        </logic:iterate>
        </tbody>
        <tfoot>
          <tr>
            <td nowrap="nowrap" style="border:1px solid #FFFFFF;width:30px; background-color:#FFFFFF"><input type="checkbox" name="allchecked" id="allchecked" /></td>
            <td colspan="2" nowrap="nowrap" style="border:1px solid #FFFFFF; background-color:#FFFFFF">全选&nbsp;&nbsp;&nbsp;
	            <a id="deleteBuyC"><img src="${ctx}/images/btnDelete.gif" width="65" height="20" align="absmiddle" /></a>&nbsp;&nbsp; 
	            <a id="selectBuyC"><img src="${ctx}/images/btnAdd.gif" width="65" height="20" align="absmiddle" /></a>
	        </td>
            <td nowrap="nowrap" style="border:1px solid #FFFFFF; background-color:#FFFFFF">&nbsp;</td>
            <td colspan="7" nowrap="nowrap" style=" text-align:right; border:1px solid #FFFFFF; padding-right:5px; background-color:#FFFFFF"> 预付金额合计 </td>
            <td nowrap="nowrap"  style=" border:1px solid #FFFFFF;  background-color:#FFFFFF; text-align:right"><span id="advanceMoneyE">0.00</span>元</td>
          </tr>
        </tfoot>
      </table>
      <div class="div_tiao"> &nbsp;&nbsp;产品信息 </div>
      <div style="text-align:right; width:100%">单位：元</div>
      <table width="100%" border="0" cellpadding="0" cellspacing="0" class="biao1" id="table" style="border-left:1px solid #FFFFFF;">
        <thead>
          <tr>
            <th nowrap="nowrap" style="border-left:1px solid #c2c2c2;">选择</th>
            <th nowrap="nowrap" width="30">序号</th>
            <th nowrap="nowrap">入库单号</th>
            <th nowrap="nowrap">要求付款日期</th>
            <th nowrap="nowrap">产品合同号</th>
            <th nowrap="nowrap">公司合同号</th>
            <th nowrap="nowrap">产品编码</th>
            <th nowrap="nowrap">产品名称</th>
            <th nowrap="nowrap">规格型号</th>
            <th nowrap="nowrap">单位</th>
            <th nowrap="nowrap">采购单价</th>
            <th width="90" nowrap="nowrap">入库金额</th>
            <th width="90" nowrap="nowrap">已指定金额</th>
            <th width="90" nowrap="nowrap">收票金额</th>
            <th width="90" nowrap="nowrap">返厂金额</th>
            <th nowrap="nowrap" width="108px">指定金额</th>
          </tr>
        </thead>
        <tbody id="inStock">
        	<logic:iterate id="product" name="productList" indexId="index">
				<tr>
					<td style="border-left:1px solid #c2c2c2;">
						<input type="hidden" name="inStockIdAndProductId" id="inStockIdAndProductId" value="${product.inStockId}#${product.productId}" />
						<input type="hidden" name="inStockId" id="inStockId" value="${product.inStockId}"  /><input type="hidden" name="productId" id="productId" value="${product.productId}" />
						<input type="hidden" name="inStockBuyBuyContractId" id="inStockBuyBuyContractId" value="${product.buyContractId}" />
						<input type="checkbox"  />
					</td>
		            <td width="40" nowrap="nowrap"  height="18">${index+1}&nbsp;</td>
		            <td nowrap="nowrap" >${product.inStockId}&nbsp;</td>
		            <td nowrap="nowrap" >${product.requestAccountDate}&nbsp;</td>
		            <td nowrap="nowrap" >${product.productContractCode}&nbsp;</td>
		            <td nowrap="nowrap" >${product.companyContractCode}&nbsp;</td>
		            <td nowrap="nowrap" >${product.productCode}&nbsp;</td>
		            <td nowrap="nowrap" >${product.productName}&nbsp;</td>
		            <td nowrap="nowrap" >${product.productType}&nbsp;</td>
		            <td nowrap="nowrap" >${product.productUnit}&nbsp;</td>
		            <td nowrap="nowrap" style=" text-align:right;"><fmt:formatNumber value="${product.buyContractPrice}" pattern="#,##0.00000#"/>&nbsp;</td>
		            <td nowrap="nowrap" style=" text-align:right;"><fmt:formatNumber value="${product.inStockMoney}" pattern="#,##0.00000#"/>&nbsp;</td>
		            <td nowrap="nowrap" style=" text-align:right;"><fmt:formatNumber value="${product.yzdMoney}" pattern="#,##0.00000#"/>&nbsp;</td>
		            <td nowrap="nowrap" style=" text-align:right;"><fmt:formatNumber value="${product.spMoney}" pattern="#,##0.00000#"/>&nbsp;</td>
		            <td nowrap="nowrap" style=" text-align:right;"><fmt:formatNumber value="${product.fcMoney}" pattern="#,##0.00000#"/>&nbsp;</td>
		            <td style="text-align:right"><input type="text" name="appointMoney" id="appointMoney" style="width:90px; text-align:right" onchange="javascript:changeCount(this.id);" value="${product.zdMoney}" />&nbsp;&nbsp;</td>
		          </tr>
		      </logic:iterate>
        </tbody>
        <tfoot>
          <tr>
            <td nowrap="nowrap" style="border:1px solid #FFFFFF; width:30px; background-color:#FFFFFF">
            <input id="allcheckedInStock" type="checkbox" name="checkbox6" id="checkbox6" />
            </td>
            <td colspan="3" nowrap="nowrap" style="border:1px solid #FFFFFF; background-color:#FFFFFF">全选&nbsp;&nbsp;&nbsp;
	            <img id="btnDeleteInstock" src="${ctx}/images/btnDelete.gif" width="65" height="20" align="absmiddle" />&nbsp;&nbsp; 
	            <img id="btnAddInStock" src="${ctx}/images/btnAdd.gif" width="65" height="20" align="absmiddle" /></td>
            <td nowrap="nowrap" style="border:1px solid #FFFFFF; background-color:#FFFFFF">&nbsp;</td>
            <td nowrap="nowrap" style="border:1px solid #FFFFFF; background-color:#FFFFFF">&nbsp;</td>
            <td colspan="9" nowrap="nowrap" style=" text-align:right; border:1px solid #FFFFFF; padding-right:5px; background-color:#FFFFFF"> 指定金额合计 </td>
            <td nowrap="nowrap"  style=" border:1px solid #FFFFFF;  background-color:#FFFFFF; text-align:right" ><span id="appointMoneyE">0.00</span>元</td>
          </tr>
        </tfoot>
      </table>
      <br />
      <div class="div_tiao"> &nbsp;&nbsp;特殊说明</div>
      <table width="100%" border="0" cellpadding="0" cellspacing="0" class="biao3">
        <tr>
          <td class="td_03" width="20%">特殊说明</td>
          <td class="td_04" ><textarea name="text" id="text" cols="100" rows="4">${bpid.text}</textarea>
          </td>
        </tr>
      </table>
      <br />
      <div class="div_tiao"> &nbsp;&nbsp;评审意见</div>
      <table border="0"  cellpadding="0" cellspacing="0" align="center" width="460">
        <tr>
          <td height="20px" colspan="2" >产品总监评审意见：</td>
        </tr>
        <tr>
          <td nowrap="nowrap">1.付款时间是否符合</td>
          <td height="20px" nowrap="nowrap">
          	 <c:if test = "${strIder[0]==0}">
          	 
          	 </c:if>
          	<input type="checkbox" name="checkbox1" id="checkbox1" disabled="disabled"/>符合&nbsp;&nbsp;
            <input type="checkbox" name="checkbox2" id="checkbox2" disabled="disabled"/>不符合 
          </td>
        </tr>
        <tr>
          <td nowrap="nowrap">2.付款金额是否符合</td>
          <td height="20px" nowrap="nowrap">
            <input type="checkbox" name="checkbox3" id="checkbox3" disabled="disabled"/>符合&nbsp;&nbsp;
            <input type="checkbox" name="checkbox4" id="checkbox4" disabled="disabled"/>不符合 
          </td>
        </tr>
        <tr>
          <td nowrap="nowrap">3.付款类型是否符合</td>
          <td height="20px" nowrap="nowrap">
          	<input type="checkbox" name="checkbox5" id="checkbox5" disabled="disabled"/>符合&nbsp;&nbsp;
            <input type="checkbox" name="checkbox6" id="checkbox6" disabled="disabled"/>不符合 
          </td>
        </tr>
        <tr>
          <td nowrap="nowrap">4.付款方式是否符合</td>
          <td height="20px" nowrap="nowrap">
	          	<input type="checkbox" name="checkbox7" id="checkbox7" disabled="disabled"/>符合&nbsp;&nbsp;
	            <input type="checkbox" name="checkbox8" id="checkbox8" disabled="disabled"/>不符合
		  </td>
        </tr>
        <tr>
          <td width="320" nowrap="nowrap">5.供货商付款信息是否符合</td>
          <td height="20px" width="150" nowrap="nowrap">
            <input type="checkbox" name="checkbox9" id="checkbox9" disabled="disabled"/>符合&nbsp;&nbsp;
            <input type="checkbox" name="checkbox10" id="checkbox10" disabled="disabled"/>不符合 
          </td>
        </tr>
        <tr>
          <td colspan="2" valign="top"><table width="98%" border="0" cellpadding="0" cellspacing="0">
              <tr>
                <td width="60px" valign="top" style="padding:5px 0 5px 0;" nowrap="nowrap">补充说明：</td>
                <td style="padding:5px 0 5px 0;">${tf:replaceBr(bpid.proMajText)}&nbsp;</td>
              </tr>
            </table></td>
        </tr>
        <tr>
          <td height="20px">签字：${bpid.proMajName}</td>
          <td>日期：${bpid.proMajDate}</td>
        </tr>
        <tr>
          <td height="20px" colspan="2">&nbsp;</td>
        </tr>
        <tr>
          <td height="20px" colspan="2">采购主管评审意见：</td>
        </tr>
        <tr>
          <td>&nbsp;</td>
		  <td height="20px">
	      	 <input type="checkbox" name="buyManIdea1" id="buyManIdea1" disabled="disabled">符合&nbsp;&nbsp;
	         <input type="checkbox" name="buyManIdea0" id="buyManIdea0" disabled="disabled"/>不符合
	      </td>            
        </tr>
        <tr>
          <td colspan="2" valign="top"><table width="98%" border="0" cellpadding="0" cellspacing="0">
              <tr>
                <td width="60px" valign="top" style="padding:5px 0 5px 0;" nowrap="nowrap">补充说明：</td>
                <td style="padding:5px 0 5px 0;">${tf:replaceBr(bpid.buyManText)}&nbsp;</td>
              </tr>
            </table></td>
        </tr>
        <tr>
          <td height="20px">签字：${bpid.buyManName}</td>
          <td>日期：${bpid.buyManDate}</td>
        </tr>
        <tr>
          <td height="20px" colspan="2" >&nbsp;</td>
        </tr>
        <tr>
          <td height="20px" colspan="2">运营总监评审意见：</td>
        </tr>
        <tr>
          <td>&nbsp;</td>
	      <td height="20px">
	      	 <input type="checkbox" name="opeMajIder1" id="opeMajIder1" disabled="disabled" />符合&nbsp;&nbsp;
		     <input type="checkbox" name="opeMajIder0" id="opeMajIder0" disabled="disabled" />不符合
	      </td>         	
        </tr>
        <tr>
          <td colspan="2" valign="top"><table width="98%" border="0" cellpadding="0" cellspacing="0">
              <tr>
                <td width="60px" valign="top" style="padding:5px 0 5px 0;" nowrap="nowrap">补充说明：</td>
                <td style="padding:5px 0 5px 0;" >${tf:replaceBr(bpid.opeMajText)}&nbsp;</td>
              </tr>
            </table></td>
        </tr>
        <tr>
          <td height="20px">签字：${bpid.opeMajName}</td>
          <td>日期：${bpid.opeMajDate}</td>
        </tr>
      </table>
      </td>
    <td >&nbsp;</td>
  </tr>
  <tr>
    <td></td>
    <td height="50px" align="center" valign="bottom"><img id="btnSave" src="${ctx}/images/btnSave.gif" width="65" height="20" /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <img id="btnCreate" src="${ctx}/images/btnSubmit.gif" width="65" height="20" /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <a id="backBtn"><img src="${ctx}/images/btnBack.gif" /></a></td>
    <td></td>
  </tr>
</table>
<br />
</form>
</body>
</html>
