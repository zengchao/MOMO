/* 
  Jiami.java
  CMPayClient

  Created by 超 曾 on 12-3-13.
  Copyright (c) 2012年 My Company. All rights reserved.
*/

package test;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.security.Key;
import java.security.KeyFactory;
import java.security.PublicKey;
import java.security.SecureRandom;
import java.security.spec.KeySpec;
import java.security.spec.X509EncodedKeySpec;
import java.util.Arrays;
import java.util.Random;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;

//import yycom.util.io.IoUtil;

public class TestPay{
	private static byte[] data=new byte[4096];
	private static Random R=new Random();
    
	public static void fill() throws IOException{
		File f=new File("./T" + Integer.toHexString(R.nextInt()) + ".tmp");
		FileOutputStream fos=new FileOutputStream(f);
		try{
			for(int i=0;i < 10000;i++){
				fos.write(data);
			}
		}
		finally{
			fos.close();
		}
	}
    
	private final static char[] CS="0123456789ABCDEF".toCharArray();
    
	public static String bytesToHex(byte[] bs){
		int len=bs.length;
		char[] cs=CS;
		char[] rs=new char[bs.length << 1];
		for(int i=0;i < len;i++){
			int b=bs[i] & 0xFF;
			rs[i + i]=cs[b >> 4];
			rs[i + i + 1]=cs[b & 0xF];
		}
		return new String(rs);
	}
    
	/**
	 * des加密
	 * @param data
	 * @param key
	 * @return
	 */
	public final static byte[] desEncrypt(byte[] data,byte[] key){
		Cipher cipher=null;
		try{
			Key key1=new SecretKeySpec(key,"AES");
			cipher=Cipher.getInstance("AES/ECB/PKCS5Padding");
			cipher.init(Cipher.ENCRYPT_MODE,key1);
			return cipher.doFinal(data);
		}
		catch(Throwable t){
			t.printStackTrace();
			// System.out.println("加密失败");
			return null;
		}
	}
    
	public final static byte[] tdes3Encrypt(byte[] data,byte[] key){
		DES des=new DES();
		byte[] k=new byte[8];
		System.arraycopy(key,0,k,0,8);
		data=des.DesEncrypt(k,data,1);
        
		System.arraycopy(key,8,k,0,8);
		data=des.DesEncrypt(k,data,0);
        
		System.arraycopy(key,0,k,0,8);
		data=des.DesEncrypt(k,data,1);
		return data;
	}
    
	public final static byte[] dtdes3Encrypt(byte[] data,byte[] key){
		DES des=new DES();
		byte[] k=new byte[8];
		System.arraycopy(key,16,k,0,8);
		data=des.DesEncrypt(k,data,0);
        
		System.arraycopy(key,8,k,0,8);
		data=des.DesEncrypt(k,data,1);
        
		System.arraycopy(key,0,k,0,8);
		data=des.DesEncrypt(k,data,0);
		return data;
	}
    
	public final static byte[] des3Encrypt(byte[] data,byte[] key){
		try{
			// 生成密钥
			SecretKey deskey=new SecretKeySpec(key,"DESede");
            
			// 加密
			Cipher c1=Cipher.getInstance("DESede");
			c1.init(Cipher.ENCRYPT_MODE,deskey);
			return c1.doFinal(data);
            
		}
		catch(Throwable t){
			t.printStackTrace();
			// System.out.println("加密失败");
			return null;
		}
	}
    
	public final static byte[] getRandomBytes(int n){
		SecureRandom s=new SecureRandom();
		byte[] r=new byte[n];
		for(int i=0;i < n;i++){
			int t=s.nextInt() & 0x7F;
			r[i]=(byte)t;
		}
		return r;
	}
    
	//private final static String publicKey="30818902818100EE9D3074A90B35A780F0138ADEA6CFD055E77E4480D89755AFE01AE9CE3C0EBB6AF73355A9B269039D0C5E2C6113C75D7ABAE5D3E51E2AF0C8E8F37B2F637638472EF3CB54EB042F6B3814EEA50E3D8919ED96F0E3AAF7BF8E76EBC40C205704C98EA70C0264FB96D0016FD1F0A9B657AE6DF30E48A35EF63B9C5AA20B4AFE390203010001";
	private static String publicKey="30818902818100EE9D3074A90B35A780F0138ADEA6CFD055E77E4480D89755AFE01AE9CE3C0EBB6AF73355A9B269039D0C5E2C6113C75D7ABAE5D3E51E2AF0C8E8F37B2F637638472EF3CB54EB042F6B3814EEA50E3D8919ED96F0E3AAF7BF8E76EBC40C205704C98EA70C0264FB96D0016FD1F0A9B657AE6DF30E48A35EF63B9C5AA20B4AFE390203010001";
    
	public static byte[] getPinBlock(String s){
		int len=s.length();
		byte[] bs=new byte[8];
		for(int i=0;i < bs.length;i++){
			bs[i]=(byte)0xFF;
		}
		int ic=0;
		for(int i=0;i < bs.length && ic < len;i++){
			bs[i]&=((s.charAt(ic++) - '0') << 4) | 0xF;
			if(ic >= len){
				break;
			}
			bs[i]&=(s.charAt(ic++) - '0') | 0xF0;
		}
		return bs;
	}
    
    //	public static byte[] hexToBytes(String s){
    //		int len=s.length();
    //		byte[] bs=new byte[len >> 1];
    //		int r=0;
    //		for(int i=0;i < len;i++){
    //			int n=s.charAt(i);
    //			if(n >= '0' && n <= '9'){
    //				n-='0';
    //			}
    //			else if(n >= 'A' && n <= 'F'){
    //				n-='A' - 10;
    //			}
    //			else if(n >= 'a' && n <= 'f'){
    //				n-='a' - 10;
    //			}
    //			if((i & 1) == 1){
    //				bs[i >> 1]=(byte)(r | n);
    //			}
    //			else{
    //				r=n << 4;
    //			}
    //		}
    //		return bs;
    //	}
	
	public static byte[] hexToBytes(String s){
		int len=s.length();
		byte[] bs=new byte[len >> 1];
		int r=0;
		for(int i=0;i < len;i++){
			int n=s.charAt(i);
			if(n >= '0' && n <= '9'){
				n-='0';
			}
			else if(n >= 'A' && n <= 'F'){
				n-='A' - 10;
			}
			else if(n >= 'a' && n <= 'f'){
				n-='a' - 10;
			}
			if((i & 1) == 1){
				bs[i >> 1]=(byte)(r | n);
			}
			else{
				r=n << 4;
			}
		}
		return bs;
	}
    
    //	/**
    //	 * 加密
    //	 * @param data
    //	 * @param key
    //	 * @return
    //	 */
    //	public final static byte[] rsaEncrypt(byte[] data,byte[] key){
    //		Cipher cipher=null;
    //		try{
    //			data=makeRsaData(data);
    //			System.out.println("填充后的随机数:"+bytesToHex(data));
    //			KeySpec keySpec=new X509EncodedKeySpec(key);
    //			KeyFactory factory=KeyFactory.getInstance("RSA");
    //			PublicKey k=factory.generatePublic(keySpec);
    //			cipher=Cipher.getInstance("RSA/ECB/NoPadding");// PKCS5Padding
    //			cipher.init(Cipher.ENCRYPT_MODE,k);
    //			return cipher.doFinal(data);
    //		}
    //		catch(Throwable t){
    //			t.printStackTrace();
    //			// System.out.println("加密失败");
    //			return null;
    //		}
    //	}
	
	/**
	 * 加密
	 * @param data
	 * @param key
	 * @return
	 */
	public final static byte[] rsaEncrypt(byte[] data,byte[] key){
		Cipher cipher=null;
		try{
			KeySpec keySpec=new X509EncodedKeySpec(key);
			KeyFactory factory=KeyFactory.getInstance("RSA");
			PublicKey k=factory.generatePublic(keySpec);
			if(data.length >=128){
				cipher=Cipher.getInstance("RSA/ECB/NoPadding");
			}
			else{
				cipher=Cipher.getInstance("RSA/ECB/PKCS1Padding");
			}
			cipher.init(Cipher.ENCRYPT_MODE,k);
			data=cipher.doFinal(data);
			return data;
		}
		catch(Throwable t){
			t.printStackTrace();
			// System.out.println("加密失败");
			return null;
		}
	}
    
    
	private final static String PRE="30819F300D06092A864886F70D010101050003818D00";
    
	private final static String SERVER="http://211.138.236.209:31021";
	
	private static String getSub(String s,String pre){
		int i=s.indexOf("<" + pre + ">") + pre.length() + 2;
		int end=s.indexOf("</" + pre,i);
		return s.substring(i,end);
	}
    
	static int SERLNO=new Random().nextInt(1000000);
	
	public static String getPK() throws Exception{
		String s="<ROOT><BODY><SERLNO>2</SERLNO></BODY><HEAD><PLUGINVER>cyber</PLUGINVER><SESSIONID></SESSIONID><TXNCD>101000</TXNCD><VERSION>1.0</VERSION></HEAD></ROOT>";
		byte[] rs=IoUtil.getBytesByURL(SERVER+"/ccaweb/CCLIMCA3/101000.dor",s.getBytes());
		String r=new String(rs,"UTF-8");
		System.out.println(r);
		return r;
	}
    
	public static String login() throws Exception{
		getPK();
		publicKey="30818902818100EE9D3074A90B35A780F0138ADEA6CFD055E77E4480D89755AFE01AE9CE3C0EBB6AF73355A9B269039D0C5E2C6113C75D7ABAE5D3E51E2AF0C8E8F37B2F637638472EF3CB54EB042F6B3814EEA50E3D8919ED96F0E3AAF7BF8E76EBC40C205704C98EA70C0264FB96D0016FD1F0A9B657AE6DF30E48A35EF63B9C5AA20B4AFE390203010001";
		String pk="30819F300D06092A864886F70D010101050003818D00"+publicKey;
		String user="15084968031";
		String pwd="111111";
		byte[] bs=pwd.getBytes("UTF-8");
		bs=rsaEncrypt(bs,hexToBytes(pk));
		String keys=bytesToHex(bs);
		String s="<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n<ROOT><BODY><SVRPSW>"+keys+"</SVRPSW><SERLNO>"+(SERLNO++)+"</SERLNO><MBLNO>"+user+"</MBLNO></BODY><HEAD><PLUGINVER>cyber</PLUGINVER><SESSIONID>iZgkdB0000076793</SESSIONID><TXNCD>201190</TXNCD><VERSION>1.0</VERSION></HEAD></ROOT>";
		
		//s="<ROOT><BODY><SVRPSW>13DB37423E40FF708E343D2C301B6730D953F45F5B5398A3D29565D714766BB6C02713206115A60D8473F65C0426D3B60D3879B095BFD86575E9954AB3B6F8104598178BD79ECD775AA3AB2548104D6385665BACA90892E85A669839C334D79812FD77DF31D8413EA720B906EC5491923341C0A9E9CDB02A0ED922A8124FF0CA</SVRPSW><SERLNO>187339</SERLNO><MBLNO>15084968031</MBLNO></BODY><HEAD><PLUGINVER>cyber</PLUGINVER><SESSIONID>iZgkdB0000076793</SESSIONID><TXNCD>201190</TXNCD><VERSION>1.0</VERSION></HEAD></ROOT>";
		//String s="<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n<ROOT><BODY><SVRPSW>CC1E86817B7498E6EB5E5C94B5574772AD41D5A6A85D79AC879AB873335E07A1BC2623B7FFB2110A15906CA85B5177F439C0E05E96DA34D9DFC58E8A227A8D64A72C3EE9BC820C6242BABE5B8C75CC628D8B30651B3E1F032A28481C3BA3B880A0559E3E16F0D43D045F46C64FF1DA07F8BA4B58D420276D9655C914A6588044</SVRPSW><MBLNO>15874074997</MBLNO><SERLNO>" + (SERLNO++) + "</SERLNO></BODY><HEAD><VERSION>1.0</VERSION><TXNCD>201190</TXNCD><SESSIONID></SESSIONID><PLUGINVER>cyber</PLUGINVER></HEAD></ROOT>";
		System.out.println(s);
        
		byte[] rs=IoUtil.getBytesByURL(SERVER+"/ccaweb/CCLIMCA1/201190.dor",s.getBytes());
		String r=new String(rs,"UTF-8");
        
		System.out.println(r);
		return getSub(r,"SESSIONID");
        
		// return r;
	}
    
    
	public final static byte[] makeRsaData(byte[] ran){
		byte[] bs=getRandomBytes(128);
		for(int i=0;i < 128;i++){
			if(bs[i] == 0){
				bs[i]=77;
			}
		}
		bs[0]=0;
		bs[1]=2;
        
		bs[97]=0;
		bs[98]=0x30;
		bs[99]=0x1c;
		bs[100]=0x04;
		bs[101]=0x10;
		System.arraycopy(ran,0,bs,102,16);
		bs[118]=0x04;
		bs[119]=0x08;
		return bs;
	}
    
	// private static byte[] getRsaData(byte[] pre) throws IOException{
	// //byte[] bs=new byte[128];
	// //Arrays.fill(bs,(byte)0xFF);
	// //bs[0]=0;
	// //bs[1]=2;
	// //bs[111]=0;
	// //System.arraycopy(pre,0,bs,112,16);
	// ByteArrayOutputStream bos=new ByteArrayOutputStream();
	// System.out.println(bos.size()+"<=== 0x00 0x02");
	// bos.write(0);
	// bos.write(2);
	// byte[] fill=getRandomBytes(128-3-16-14);
	// System.out.println("======"+bos.size());
	// for(int i=0;i<fill.length;i++){
	// if(fill[i]==0){
	// fill[i]=77;
	// }
	// }
	// bos.write(fill);
	// System.out.println("======"+bos.size());
	// //for(int i=0;i<(128-3-16-14);i++){
	// // bos.write(0xFF);
	// //}
	// System.out.println(bos.size()+"<=== 0x00 0x30 0x1c 0x04 0x10");
	// bos.write(0);
	// bos.write(0x30);
	// bos.write(0x1c);
	// bos.write(0x04);
	// bos.write(0x10);
	//		
	//		
	// System.out.println(bos.size()+"<=== 随机数");
	// bos.write(pre);
	//		
	// System.out.println(bos.size()+"<=== 0x04 0x08");
	// bos.write(0x04);
	// bos.write(0x08);
	//		
	// for(int i=0;i<8;i++){
	// bos.write(0xFF);
	// }
	// byte[] bs=bos.toByteArray();
	// System.out.println("填充后: "+bs.length+"  "+bytesToHex(bs));
	// return bs;
	// }
    
	// public static void main(String[] args){
	// // byte[] src=hexToBytes("BB7E4D252B320EC5");
	// byte[] ke=hexToBytes("31313232343437373131323234343737");
	//		
	// // byte[] r=dtdes3Encrypt(src,ke);
	// // System.out.println(bytesToHex(r));
	// //byte[] src=getPinBlock("123123");
	// //byte[] rs=tdes3Encrypt(src,ke);
	// //System.out.println(bytesToHex(rs));
	// //System.out.println("CA1112C0CECB35D8");
	// // BB7E4D252B320EC5
	// String
	// pk=bytesToHex(rsaEncrypt(getRsaData(ke),hexToBytes(PRE+publicKey)));
	// System.out.println(pk);
	// }
	
	final static void oddCheck(byte[] data){
		int len=data.length;
		for(int i=0;i < len;i++){
			int t=data[i] & 0x7F;
			int p=Integer.bitCount(t);
			if((p & 1) == 0){
				t|=0x80;
			}
			data[i]=(byte)t;
		}
	}
    
	public static void main(String[] args) throws Exception{
		String session=login();
		//Thread.sleep(10000);
		System.out.println("SESSIONID:" + session);
		byte[] b24=getRandomBytes(24);
		System.arraycopy(b24,0,b24,16,8);
        
		System.out.println("随机数: " + bytesToHex(Arrays.copyOf(b24,16)));
		oddCheck(b24);
		System.out.println("奇校验后的随机数: " + bytesToHex(Arrays.copyOf(b24,16)));
		String pin="111111";
		System.out.println("PIN: " + pin);
		byte[] pb=getPinBlock(pin);
		System.out.println("PinBlock: " + bytesToHex(pb));
        
		String pw=bytesToHex(des3Encrypt(pb,b24));
		pw=pw.substring(0,16);
		System.out.println("3DES加密后的PinBlock: " + pw);
		byte[] b16=Arrays.copyOf(b24,16);
        
		byte[] rsaK=b16;
		String pk=bytesToHex(rsaEncrypt((rsaK),hexToBytes(PRE + publicKey)));
		System.out.println("公钥:" + publicKey);
		System.out.println("RSA/ECB/PKCS1Padding用公钥加密后的已填充随机数: " + pk);
		String up="<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n<ROOT><BODY><OPAYPW>" + pw + "</OPAYPW><MBLNO>15084968031</MBLNO><OPAYKEY>" + pk + "</OPAYKEY><PSWTYP>P</PSWTYP><NPAYKEY>" + pk + "</NPAYKEY><NPAYPW>" + pw + "</NPAYPW><SERLNO>" + (SERLNO++) + "</SERLNO></BODY><HEAD><VERSION>1.0</VERSION><TXNCD>202010</TXNCD><SESSIONID>" + session + "</SESSIONID><PLUGINVER>cyber</PLUGINVER></HEAD></ROOT>";
        
		System.out.println("上行数据: " + up);
        
		byte[] bs=up.getBytes();
		String url=SERVER+"/ccaweb/CCLIMCA1/202010.dor";
        
		byte[] rs=IoUtil.getBytesByURL(url,bs);
		System.out.println("下行数据:" + new String(rs,"UTF-8"));
	}
}






