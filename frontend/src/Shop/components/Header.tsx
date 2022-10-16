import React, { CSSProperties } from "react";
import { User } from "../";

interface Props {
  onSignIn: () => void;
  onSignOut: () => void;
  user: User | null
}

const headerStyle: CSSProperties = {
  padding: 8,
  backgroundColor: "#3EAC62",
  color: "white",
  width: "100%",
  display: "flex",
  alignItems: "center",
  justifyContent: "space-between",
};

export default function Header(props: Props) {
  return (
    <header style={headerStyle}>
      <div style={{ fontWeight: "bold" }}>SUS Tech</div>

      <div>
        {props.user === null ? (
          <button onClick={props.onSignIn}>Login</button>
        ) : (
          <div>
            @{props.user.username} <button type="button" onClick={props.onSignOut}>Logout</button>
          </div>
        )}
      </div>
    </header>
  );
}
