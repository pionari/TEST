package com.kh.livro.dto;

public class FollowerDto {

	private int follower_no;
	private String member_id;
	private String member_nickname;
	private String follower_id;
	private String follower_nickname;

	public FollowerDto() {
		super();
	}

	public FollowerDto(int follower_no, String member_id, String member_nickname, String follower_id, String follower_nickname) {
		super();
		this.follower_no = follower_no;
		this.member_id = member_id;
		this.member_nickname = member_nickname;
		this.follower_id = follower_id;
		this.follower_nickname = follower_nickname;
	}

	public int getFollower_no() {
		return follower_no;
	}

	public void setFollower_no(int follower_no) {
		this.follower_no = follower_no;
	}

	public String getMember_id() {
		return member_id;
	}

	public void setMember_id(String member_id) {
		this.member_id = member_id;
	}

	public String getMember_nickname() {
		return member_nickname;
	}

	public void setMember_nickname(String member_nickname) {
		this.member_nickname = member_nickname;
	}

	public String getFollower_id() {
		return follower_id;
	}

	public void setFollower_id(String follower_id) {
		this.follower_id = follower_id;
	}

	public String getFollower_nickname() {
		return follower_nickname;
	}

	public void setFollower_nickname(String follower_nickname) {
		this.follower_nickname = follower_nickname;
	}

}
