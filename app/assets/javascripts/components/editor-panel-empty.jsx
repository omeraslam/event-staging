var EditorPanelEmpty = React.createClass({
    getInitialState: function() {
        return { items: this.props.items}
    },
    getDefaultProps: function() {
        return { items: [], current_selection: null}
    },

    componentDidMount: function() {
   
    },

    render: function() {


   

        return (
            <div className="editor-panel empty">
                <i className="icon icon-ticket"> </i>
                <h1>{this.props.title}</h1>
                <p>{this.props.description}</p>
                <p><button className="btn btn-primary">{this.props.button_text}</button> </p>
            </div>
        )
   } 
});








 


