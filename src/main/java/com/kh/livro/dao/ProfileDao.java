package com.kh.livro.dao;

public interface ProfileDao {
	
	String NAMESPACE = "profile.";
	
	public int profileInsert(String member_id);
	public int profileUpdate(String member_id);

}
